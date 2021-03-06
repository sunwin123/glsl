/* lame-ass tunnel by kusma */
// rotwang mod* some blending rings

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	
	float speed = time*0.25;
	vec2 pos = (gl_FragCoord.xy - resolution * 0.5) / resolution.yy;
	float th = atan(pos.y, pos.x) / (2.0 * 3.1415926) + 0.5;
	float dd = length(pos);
	th = clamp(dd, 0.0,0.5);
	float tca = clamp(th, 0.4,0.5);
	float d = 0.25 / dd + speed;

	vec3 uv = vec3(th + d, th - d, th + sin(d));
	
	float a = 0.5 + cos(uv.x * 3.1415926 * 2.0) * 0.5*speed;
	float b = 0.5 + cos(uv.y * 3.1415926 * 2.0) * 0.5;
	float c = 0.5 + cos(uv.z * 3.1415926 * 6.0) * 0.5;
	
	vec3 color = mix(vec3(1.0, 0.8, 0.9), vec3(0.1, 0.1, 0.2), pow(a, 0.25)) * 0.75;
	color += mix(vec3(0.8, 0.9, 1.0), vec3(0.1, 0.1, 0.2),  pow(b, 0.66))*2.0;
	color *= dd*4.0;
	
	gl_FragColor = vec4(color * clamp(dd, 0.3, 1.0), 1.0);
}