#ifdef GL_ES
precision mediump float;
#endif

// First test of recursive rotozoomer.
// by Optimus

// gotta save this unfinished version atm because I am late for an appointment :)

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

void main( void ) {
	vec2 position = gl_FragCoord.xy / resolution.xy;
	vec2 centered_position = position - vec2(0.5);

	vec3 color = vec3(0.0);

	vec3 test = vec3(sin(centered_position.x * 4.0) * 4.0 + 4.0, sin(centered_position.y * 8.0) * 1.0 + 1.0, sin(centered_position.x * 8.0 + centered_position.y * 2.0) * 2.0);

	if (abs(centered_position.x) > 0.495 || abs(centered_position.y) > 0.495)
	{
		color = test;
	}
	else if (abs(centered_position.x) > 0.475 || abs(centered_position.y) > 0.475)
	{
		color = vec3(0.25);
	}
	else
	{
		float angle = time * 0.5;
		float xp = centered_position.x * sin(angle) - centered_position.y * cos(angle);
		float yp = centered_position.x * cos(angle) + centered_position.y * sin(angle);
		centered_position = vec2(xp, yp) * 1.25;
		color = texture2D(backbuffer, centered_position + vec2(0.5)).rgb - 0.025;
	}

	gl_FragColor = vec4(color, 1.0) * (pow(length(centered_position), 0.05));
}