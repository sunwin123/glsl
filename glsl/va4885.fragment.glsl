#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
varying vec2 surfacePosition;
const float max_iteration = 200.0;


vec2 calculate(vec2 x,vec2 c) {
	return vec2(
		(x.x*x.x)-(x.y*x.y),
		(x.x*x.y)+(x.y*x.x)
	)+c;
}


void main( void ) {

	vec2 p = surfacePosition;
	
	float iteration = 0.0;
	for(float i = 0.0; i <= max_iteration; i++)
	{
		if(length(p) > 4.) { break; }
		p = calculate(p,vec2(sin(time), cos(time)));
		iteration++;
	}
	
	float color = iteration/max_iteration;
	gl_FragColor = vec4(color*10.0,color-.1,color/20.0, 1.0);
}