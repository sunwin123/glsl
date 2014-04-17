#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main(void)
{
	vec2 p = (2.0*gl_FragCoord.xy-resolution.xy)/resolution.y;
	p.y -= 0.25;
	
	// background color
	vec3 bcol = vec3(0.4,1.0,0.7-0.07*p.y)*(1.0-0.25*length(p));
	
	
	// animate
	float tt = mod(time,1.5)/1.5;
	float ss = pow(tt,0.2)*0.5 + 0.5;
	ss -= ss*0.2*sin(tt*30.0)*exp(-tt*4.0);
	p *= vec2(0.5,1.5) + ss*vec2(0.5,-0.5);
   

	// shape
	float a = atan(p.x,p.y)/3.141593;
	float r = length(p);
	float h = abs(a);
	float d = (13.0*h - 22.0*h*h + 10.0*h*h*h)/(6.0-5.0*h);

	// color
	float s = 1.0-0.5*clamp(r/d,0.0,1.0);
	s = 0.75 + 0.75*p.x;
	s *= 1.0-0.25*r;
	s = 0.5 + 0.6*s;
	s *= 0.5+0.5*pow( 1.0-clamp(r/d, 0.0, 1.0 ), 0.1 );
	vec3 hcol = vec3(1.0,0.5*r,0.3)*s;
	
	vec3 col = mix( bcol, hcol, smoothstep( -0.01, 0.01, d-r) );

	gl_FragColor = vec4(col,1.0);
}