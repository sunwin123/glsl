#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


struct ray
{ float origin;
 float destination;
};


	
	


void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );


	gl_FragColor = vec4(0.3,0.3,0.3,1.0);

}