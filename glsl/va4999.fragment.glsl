#ifdef GL_ES
precision mediump float;
#endif

// quadratic bezier curve evaluation
// posted by Trisomie21
// knighty 11-23-2012: added variable thickness. not perfect, this is just proof of concept.

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float cuberoot( float x )
{
	if( x<0.0 ) return -pow(-x,1.0/3.0);
	return pow(x,1.0/3.0);
}

int solveCubic(in float a, in float b, in float c, out float r[3])
{
	float  p = b - a*a * 1. / 3.0;
	float  q = a * (2.0 / 27.0 *a*a - 1.0 / 3.0 *b) + c;
	float p3 = p*p*p;
	float  d = q*q + p3 * 4.0 / 27.0;
	float offset = -a * 1. / 3.0;
	if(d >= 0.0) { // Single solution
		float z = sqrt(d);
		float u = (-q + z) * 1./ 2.0;
		float v = (-q - z) * 1./ 2.0;
		u = cuberoot(u);
		v = cuberoot(v);
		r[0] = offset + u + v;
		return 1;
	}
	float u = sqrt(-p * 1./ 3.0);
	float v = acos(-sqrt( -27.0 / p3) * q * 1. / 2.0) * 1. / 3.0;
	float m = cos(v), n = sin(v)*1.732050808;
	r[0] = offset + u * (m + m);
	r[1] = offset - u * (n + m);
	r[2] = offset + u * (n - m);
	return 3;
}

float lthp0 = 30.5, lthp1 = -40.5, lthp2 = -35.5, lthp3 = 15.5, lthp4 = 50.;//thickness 4th degree polynomial coefficients
float lthick(float t){//thickness function. It would be better defined as a 1D bezier curve.
	//t=clamp(t,0.,1.);
	return lthp0+t*(lthp1+t*(lthp2+t*(lthp3+t*lthp4)));
}

float DistanceToQBSpline(in vec2 P0, in vec2 P1, in vec2 P2, in vec2 p)
{
	float dis = min(length(p-P0)-lthick(0.),length(p-P2)-lthick(1.));
	
	vec2  sb = (P1 - P0) * 2.0;
	vec2  sc = P0 - P1 * 2.0 + P2;
	vec2  sd = P1 - P0;
	
	float at = 4.*lthp4;//coef. of derivative of thickness function
	float bt = 3.*lthp3;
	float ct = 2.*lthp2;
	float dt = lthp1;
	
	float sA = dot(sc, sc);
	float sB = 3.0 * dot(sd, sc);
	float sC = 2.0 * dot(sd, sd);
	
	vec2  D = P0 - p;

	float a = sA-at;
	float b = sB-bt;
	float c = sC + dot(D, sc)-ct;
	float d = dot(D, sd)-dt;
	a=1./a;

    	float res[3];
	int n = solveCubic(b*a, c*a, d*a, res);

	float t = clamp(res[0],0.0, 1.0);
	vec2 pos = P0 + (sb + sc*t)*t;
	dis = min(dis, length(pos - p)-lthick(t));
	
    	if(n>1) {
	t = clamp(res[1],0.0, 1.0);
	pos = P0 + (sb + sc*t)*t;
	dis = min(dis, length(pos - p)-lthick(t));
	    
	t = clamp(res[2],0.0, 1.0);
	pos = P0 + (sb + sc*t)*t;
	dis = min(dis, length(pos - p)-lthick(t));	    
    	}

    	return dis;
}

void main( void ) {

	vec2 position = gl_FragCoord.xy;
	vec2 p[3];
	
	p[0] = vec2(0.200,0.200)*resolution;
	p[1] = mouse*resolution;
	p[2] = vec2(0.600,0.200)*resolution;
	
	float d = DistanceToQBSpline(p[0], p[1], p[2], position);
	
	float lineThickness = 0.0;
	float lineSoftness = 1.0;
	
	d =1.0-clamp((d - (lineThickness-1.0)) / lineSoftness, 0.0, 1.0);
	
	gl_FragColor = vec4( d,d,d, 1.0 );

}