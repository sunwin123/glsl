#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

// An attempt at Quilez's warping (domain distortions):
// http://iquilezles.org/www/articles/warp/warp.htm
// 
// Not as good as his, but still interesting.
// @SyntopiaDK, 2012



float rand(vec2 co){
	// implementation found at: lumina.sourceforge.net/Tutorials/Noise.html
	return fract(tan(dot(co.xy ,vec2(1.9898,78.233))) * 1.5453);
}

float noise2f( in vec2 p )
{
	vec2 ip = vec2(floor(p));
	vec2 u = fract(p);
	// http://www.iquilezles.org/www/articles/morenoise/morenoise.htm
	u = u*u*(3.0-2.0*u);
	//u = u*u*((6.0*u-15.0)*u+10.0);
	
	float res = mix(
		mix(rand(ip),  rand(ip+vec2(1.0,0.0)),u.x),
		mix(rand(ip+vec2(0.0,1.0)),   rand(ip+vec2(1.0,1.0)),u.x),
		u.y)
	;
	return res*res;
	//return 2.0* (res-0.5);
}

float fbm(vec2 c) {
	float f = 0.0;
	float w = 1.0;
	for (int i = 0; i < 8; i++) {
		f+= w*noise2f(c);
		c*=2.0;
		w*=0.5;
	}
	return f;
}



vec2 cMul(vec2 a, vec2 b) {
	return vec2( a.x*b.x -  a.y*b.y,a.x*b.y + a.y * b.x);
}

float pattern(  vec2 p, out vec2 q, out vec2 r )
{
	q.x = fbm( p  +0.00*time);
	q.y = fbm( p + vec2(1.0));
	
	r.x = fbm( p +1.0*q + vec2(1.7,9.2)+0.15*time );
	r.y = fbm( p+ 1.0*q + vec2(8.3,2.8)+0.126*time);
	//r = cMul(q,q+0.1*time);
	return fbm(p +1.0*r + 0.0* time);
}

const vec3 color1 = vec3(0.101961,0.619608,0.666667);
const vec3 color2 = vec3(0.666667,0.666667,0.498039);
const vec3 color3 = vec3(0,0,0.164706);
const vec3 color4 = vec3(0.666667,1,1);
void main() {
	vec2 q;
	vec2 r;
	vec2 c = 1000.0*gl_FragCoord.xy/ resolution.xy;
	float f = pattern(c*0.01,q,r);
	vec3 col = mix(color1,color2,clamp((f*f)*4.0,0.0,1.0));
	col = color2;
	col = mix(col,color3,clamp(length(q),0.0,1.0));
	col = mix(col,color4,clamp(length(r.x),0.0,1.0));
	gl_FragColor =  vec4((0.8*f*f*f+0.6*f*f+0.5*f)*col,1.0);
}

