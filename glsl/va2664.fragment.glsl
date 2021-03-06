// Plane deformations
// by Anton Platonov <platosha@gmail.com>
// twitter.com/platosha

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


const float TAU = 6.2832;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );
	vec2 p = -1.0 + 2.0 * position;
	p *= vec2( resolution.x/resolution.y, 1.0 );
	
	float alpha = -time * 0.13;
	float sinA = sin(alpha), cosA = cos(alpha);
	p = vec2(cosA*p.x+sinA*p.y, -sinA*p.x+cosA*p.y);
	
	vec2 q = p;
	vec2 dir = vec2( sin(time*0.19), cos(time*0.27) ) * 0.333;
	q = p + dir/pow(0.5, 0.6-dot(p-dir,p-dir));
	
	q = mix(q, p, sin(time*0.78));
	
	float zr = 1.0/length(q);
	float zp = 1.0/abs(q.y);
	float mc = sin(time*0.16)*.5 + .5;
	mc = smoothstep(0.0, 1.0, mc);
	mc = smoothstep(0.0, 1.0, mc);
	mc = smoothstep(0.0, 1.0, mc);
	mc = smoothstep(0.0, 1.0, mc);
	float z = mix(zr, zp, mc);
	float ur = 5.0*atan(q.x*sign(q.y), abs(q.y)) + cos(z*cos(z*z*time)*TAU+time) * 1.2 * sin( time );
	float up = q.x*z;
	float u = mix(ur, up, mc);
	vec2 uv = vec2(u, (1.0+mc*2.0)*z*z);
	
	float mv = sin(time * 0.0);
	uv = mix(uv, q, 0.0);
	
	float color = 0.0;
	color = tan(uv.x*TAU) * tan(uv.y*TAU + time*7.7);
	color = pow(abs(cos(color*TAU)), 3.0);
	
	float color2 = 0.0;
	color2 = sin(uv.x*TAU*2.0) + tan(color2);
	color2 -= 0.55;
		
	float shadow = 1.0/(z*z);
	vec3 rc = vec3(0.9, 0.9, 2.0)*color +
		  vec3(sin(time), cos(time), cos(8.0))*color2;
	rc *= shadow;
	
	gl_FragColor = vec4( rc, 1.0 );

}