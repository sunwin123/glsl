#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float julia(vec2 pos, vec2 a)
{
	const int iter = 100;
	const float pp = 0.01;
	float ret;
	vec2 ps;
	vec2 nps;
	
	ps = pos;
	ret = 0.0;
	
	for (int i = 0; i < iter; i++) {
		nps.x = ps.x * ps.x - ps.y * ps.y;
		nps.y = ps.x * ps.y + ps.x * ps.y;
		nps += a;
		ps = nps;
		if (sqrt(ps.x * ps.x + ps.y * ps.y) < 2.0) {
			ret += pp;
		}
	}
	return ret;
}

void main() {
	vec2 pos = (gl_FragCoord.xy*2.0 -resolution) / (resolution.y);
	vec2 c;
	c.x = time / 1.0;
	c.x = c.x - floor(c.x);
	c.y = time / 5.0;
	c.y = c.y - floor(c.y);
	vec4 gs = vec4(vec3(julia(pos, c)), 1.0);
	gl_FragColor = gs;
}