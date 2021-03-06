// Starfield effect, extracted from: http://glsl.heroku.com/e#883.0

#ifdef GL_ES
precision mediump float;
#endif
 
uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main(void)
{
	float scale = sin(0.0* time) * 1.5 + 2.0;

	vec2 position = (((gl_FragCoord.xy / resolution) - 0.5) * scale)  ;

	float gradient = 0.0; 
	vec3 color = vec3(0.0);
 
	vec2 centered_coord = position - vec2(-2.0, -2.0) - mouse * 4.0;

	for (float i=1.0; i<=528.0; i++)
	{
		vec2 star_pos = vec2(sin(i) * 100.0, sin(i*i*i) * 100.0);
		float z = mod(i*i - 128.0*time, 256.0);
		float fade = (256.0 - z) / 256.0;
		vec2 blob_coord = star_pos / z;
		
		gradient += ((fade / 384.0) / pow(length(centered_coord - blob_coord), 1.5)) * (fade * fade);
	}

	color = vec3(gradient * cos(time) * 2.0, gradient * sin(time) * 2.0, gradient / 2.0);

	gl_FragColor = vec4(color, 1.0 );
}
