// fuck that shit.

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {

	vec2 p = (gl_FragCoord.xy / resolution.xy-0.5)  ;
	
	vec3 color =vec3(1.0+p.y*1.2,0.8+p.y*9.,2.8+p.y*8.);
	color.r = 0.0 + sin(time*3.3)*2.0;
	color.g = 1.0;
	color.b = sin(time*0.11)*2.0+3.0;
	vec3 a;
	for ( float i	=51. ; i > 38.0; i-- ){
		color	*=	0.8;
		
		vec2 nNoise = vec2(time*(0.5+i*0.1),p.x*(sin(-p.x*20.-time*5.)*2.+0.5+i*0.3));
		const vec2 d = vec2(0.0, 1.0);
		vec2 b = floor(nNoise), f = smoothstep(vec2(0.0), vec2(1.0), fract(nNoise));
		
		float rand1 = fract(sin(dot(b, vec2(12.9898, 4.1414))) * 43758.5453);
		float rand2 = fract(sin(dot((b + d.yx), vec2(12.9898, 4.1414))) * 43758.5453);
		float rand3 = fract(sin(dot((b + d.xy), vec2(12.9898, 4.1414))) * 43758.5453);
		float rand4 = fract(sin(dot((b + d.yy), vec2(12.9898, 4.1414))) * 43758.5453);
		
		float noise = mix(mix(rand1, rand2, f.x), mix(rand3, rand4, f.x), f.y);
		p	=p *(1.0+sin(p.yx*3.-noise*4.)*(sin(time*0.44)*0.02+0.03));
		vec3 Br = vec3(0.5+cos(p.x+time*3.5)*0.1,0.5-sin(p.x+time)*0.1,1.0+cos(p.x-time*1.0)*0.1)*(1.0+sin(time*0.1)*0.8);
		a = vec3(p.y) + sin(p.x*(i*0.5)+time*2.+sin(time*(0.001*Br + i*0.0001))*5.0-(sin(time*2.8)*1.0+2.0)*0.5*noise)*0.005*i-0.05*sin(time+i*0.2);
		
		color += sin(max(vec3(0.0),pow(1.0-abs(a),vec3(1000.)*Br/(i*0.3))*0.2+pow(1.0-abs(a),vec3(30.)/Br)*.125));
	}
	color.r *= mod(gl_FragCoord.y, 2.0);
	gl_FragColor = vec4( color, 0.1 );
}
