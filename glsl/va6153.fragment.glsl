
#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

//Original code from an unknown person
//Heavily expanded upon by Citiral

//I finally understand raymarching ;)

vec3 rotXaxis(vec3 p, float rad) {
	float z2 = cos(rad) * p.z - sin(rad) * p.y;
	float y2 = sin(rad) * p.z + cos(rad) * p.y;
	p.z = z2;
	p.y = y2;
	return p;
}

vec3 rotYaxis(vec3 p, float rad) {
	float x2 = cos(rad) * p.x - sin(rad) * p.z;
	float z2 = sin(rad) * p.x + cos(rad) * p.z;
	p.x = x2;
	p.z = z2;
	return p;
}
vec3 rotZaxis(vec3 p, float rad) {
	float x2 = cos(rad) * p.x - sin(rad) * p.y;
	float y2 = sin(rad) * p.x + cos(rad) * p.y;
	p.x = x2;
	p.y = y2;
	return p;
}

//t.x = torus center size, t.y = torus volume size
float Torus(vec3 p, vec2 t)
{
	vec2 q = vec2(length(p.xz)-t.x, p.y);
    	return length(q)-t.y;
}

float Box(vec3 p, vec3 b)
{
	return length(max(abs(p) - b, 0.));	
}

float Hexagon( vec3 p, vec2 h )
{
    vec3 q = abs(p);
    return max(q.z-h.y,max(q.x+q.y*0.57735,q.y*1.1547)-h.x);
}

float map( vec3 p ){
	
	vec3 p1 = p;
	p1.x += 0.02;
	p1 = rotXaxis(p1,time - 3.1415/2. + p.x * 35. * cos(time));
	float tor1 = Torus(p1, vec2(0.02, 0.008));
	vec3 p2 = p;
	p2 = rotXaxis(p2,time);
	float tor2 = Torus(p2, vec2(0.02, 0.008));
	
	vec3 p3 = p;
	p3.x -= 0.05;
	p3 = rotZaxis(p3, p.z * 20. + time);
	p3 = rotYaxis(p3, time * 1.2);
	p3 = rotZaxis(p3, time * 1.4);
	float box1 = Hexagon(p3, vec2(0.02,0.03));
		
	return min(tor1, min(tor2, box1));
}

void main( void )
{
    	vec2 pos = (gl_FragCoord.xy*2.0 - resolution.xy) / resolution.y;
    	vec3 camPos = vec3(0., 0., 0.1);
    	vec3 camTarget = vec3(0.0, 0.0, 0.0);

    	vec3 camDir = normalize(camTarget-camPos);
    	vec3 camUp  = normalize(vec3(0.0, 1.0, 0.0));
    	vec3 camSide = cross(camDir, camUp);
    	float focus = 2.0;

	vec3 rayDir = normalize(camSide*pos.x + camUp*pos.y + camDir*focus);
    	vec3 ray = camPos;
    	float d = 0.0, total_d = 0.0;
 	const int MAX_MARCH = 64;
 	const float MAX_DIST = 0.44;
	vec4 result;
	int steps = 0;
	
    	for(int i=0; i<MAX_MARCH; ++i) {
		
        	d = map(ray);
        	total_d += d;
        	ray += rayDir * (0.25 * d);
		if(abs(d)<0.001) {
			steps = i;
			break;
		}
		if(i >= MAX_MARCH - 1) {
			steps = MAX_MARCH;
			break;
		}
		if(total_d >= MAX_DIST) {
			total_d = MAX_DIST;
			steps = MAX_MARCH;
			break;
		}
    	}
	
	float c = 1. - (float(total_d) / float(MAX_DIST));
	result = vec4(c * 0.05, c * 0.7 + 0.3 * c * sin(time), c * 0.6,1.);
	gl_FragColor = result;
}