#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy ) + mouse / 4.0;

	float color = 0.0;
	color += sin( position.x * cos( time / 15.0 ) * 100.0 ) + cos( position.y * cos( time / 100.0 ) * 40.0 );
	color += sin( position.y * 0.0*sin( time / 10.0 ) * 20.0 ) + cos( position.x * sin( time / 100.0 ) * 10.0 );
	color += sin( position.x * sin( time / 5.0 ) * 120.0 ) + sin( position.y * sin( time / 100.0 ) * 20.0 );
	color *= sin( time / 4.0 ) * 0.5;

	gl_FragColor = vec4( vec3( color * 0.25, color * 0.75, sin( color + time / 1.0 ) * 0.75 ), 0.0 );

}