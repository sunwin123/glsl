#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D bb;

float noise(vec2 p) {
	p=(p);
	return abs(fract(sin(p.x*45.11+p.y*97.23)*878.73+733.17)*2.0-1.0);
}
float wave(vec2 uv)
{
	float p1 = .90;
	float p2 = 10.0;
	float sine = sin(uv.y + time) + noise(vec2(uv.x)) * 2.0;
	sine *= .5;
	
	return (1.0 - abs(sine - uv.x) - p1) * p2;
}

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );

	vec3 color = vec3(0.0);
	
	color += vec3(1.0) * max(0.0,wave(position));
	
	//color of streams
	color = pow(color, vec3(10,50, 100));
	
	color += texture2D(bb, vec2(position.x, position.y)).xyz * 0.9 * vec3(0.5, 1.0, 0.75);
	
	gl_FragColor = vec4( color, 1.0 );

}