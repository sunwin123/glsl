#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	float color = time;

	gl_FragColor = vec4(color, color, color, 1.0);
}