/* lame-ass tunnel by kusma */

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;

uniform vec2 resolution;




float rand (float x) {
	return fract(sin(x * 24613.63) * 36817.342);	
}

void main( void ) {
	vec2 position = (gl_FragCoord.xy - resolution * 0.5) / resolution.yy;
	float th = atan(position.y, position.x) / (2.0 * 3.1415926) + 10.0;
	float dd = length(position);
	float d = 0.5 / dd + time;

	vec3 uv = vec3(th + d, th - d, th + sin(d));
	float a = 0.5 + cos(uv.x * 13.1415926*0.2) * 10.3;
	float b = 0.5 + cos(uv.y * 13.1415926 * 8.0) *10.3;
	float c = 0.5 + cos(uv.z * 13.1415926 * 6.0) * 10.5;
	float f = abs(sin(time*2.0));
	vec3 color = mix(vec3(1.0, 0.8, 1.0-f), vec3(0.5*f, 0, 0), pow(a, 0.2)) * 3.;
	color += mix(vec3(0.8, 0.9, 1.0), vec3(1110.1, 0.1, 0.2),  pow(b, 0.1)) * 0.75;
	color += mix(vec3(0.9, 0.8, 1.0), vec3(10.1, 0.2, 0.2),  pow(c, 0.1)) * 0.75;
	
	float scale = sin(0.1 * time) * 0.5 + 5.0;
	float distortion = resolution.y / resolution.x;

	vec2 position2 = (((gl_FragCoord.xy * 0.8 / resolution) ) * scale);
	position2.y *= distortion;

	float gradient = 0.0;
	vec3 color2 = vec3(0.0);
 
	float fade = 0.5;
	float z;
 
	vec2 centered_coord = position2 - vec2(12.0,11.0);

	for (float i=1.0; i<=1.0; i++)
	{
		vec2 star_pos = vec2(sin(i) * 200.0, sin(i*i*i) * 300.0);
		float z = mod(i*i - 100.0*time, 512.0);
		float fade = (456.0 - z) /300.0;
		vec2 blob_coord = star_pos / z;
		gradient += ((fade / 1500.0) / pow(length(centered_coord - blob_coord ), 1.8)) * ( fade);
	}

	color2 = color * gradient;
	
	gl_FragColor = vec4( max( color * clamp(dd, 1.0, 0.0) , color2 ) , 1.0);
}