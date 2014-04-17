#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec2 rot(vec2 p, float a) {
	return vec2(
		p.x * cos(a) - p.y * sin(a),
		p.x * sin(a) + p.y * cos(a));
}

float map(vec3 p) {
	float k = cos(p.x) + cos(p.y);
	k = max(k, -(length(abs( mod(p.yz, 6.0) ) - 3.0) - 1.0));
	k = max(k, -(length(abs( mod(p.xz, 6.0) ) - 3.0) - 1.5));
	return k;
}

//// Noise function by iq
vec4 hash(vec4 n) { return fract(sin(n)*43758.5453123); }

float tex(in vec3 x)
{
    vec3 p = floor(x);
    vec3 f = fract(x);

    f = f*f*(3.0-2.0*f);

    float n = p.x + p.y*57.0 + 113.0*p.z;
    vec4 a = hash(n + vec4(0.0, 57.0, 113.0, 170.0));
    vec4 b = hash(n + vec4(1.0, 58.0, 114.0Sssdwwww
	
    float res = mix(mix(mix(a.x, b.x, f.x), mix(a.y, b.y, f.x), f.y),
                    mix(mix(a.z, b.z, f.x), mix(a.w, b.w, f.x), f.y), f.z);
    return res*2.-1.;
}

void main( void ) {
	vec3 pos    = vec3(0, 0, time * 5.0);
	vec3 dir    = normalize(vec3( (-1.0 + 2.0 * ( gl_FragCoord.xy / resolution.xy )) * vec2(resolution.x / resolution.y, 1.0), 1.0));
	float t     = 0.0;
	dir.xy = rot(dir.xy, time * 0.2);
	dir.zx = rot(dir.zx, time * 0.1);
	for(int i = 0 ; i < 75; i++) {
		t += map(pos + dir * t) * 0.98;
	}
	vec3 inter = vec3(pos + dir * t);
	vec3 c1  = vec3(1, 2, 3);
	vec3 col = mix(c1, c1.zyx, t * 0.1) * clamp(tex(inter*2.)*20., -1.0,2.);
	col = sqrt(col * 0.01) * (map(inter + normalize(vec3(1, 2, 3))) * 3.0);
	gl_FragColor = vec4(col + t * 0.02, 1.0 );
}