#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
float z;
void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy ) ;
		
	

	gl_FragColor = vec4( 0,0,0, 1.0 );

}