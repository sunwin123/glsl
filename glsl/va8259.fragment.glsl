#ifdef GL_ES
precision mediump float;
#endif

// modified by @hintz
// closeup slow mod by @mkjpboffi

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define PI 3.14159
#define TWO_PI (PI*2.0)
#define N 6.0

void main(void) 
{
	vec2 center = (gl_FragCoord.xy);
	center.x=-100.12*sin(time/770.0);
	center.y=-100.12*cos(time/800.0);
	
	vec2 v = (gl_FragCoord.xy - resolution/20.0) / min(resolution.y,resolution.x) * 2.0;
	v.x=v.x-200.0;
	v.y=v.y-290.0;
	float col = -2.0;

	for(float i = 0.0; i < N; i++) 
	{
	  	float a = i * (TWO_PI/N) * 123.9;
		col += cos(TWO_PI*(v.y * cos(a/2.0) + v.x * sin(a/2.0) + sin(time*0.0001)*100.0 ));
	}
	
	 col /= 1.0;

	gl_FragColor = vec4(col*2.0, -col*0.2,-col*1.0, .02);


}