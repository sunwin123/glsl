#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

// SPACE PENIS fractal by kotzfrequenz 

const int MAXITER = 600;

void main( void ) {
	vec2 n = (gl_FragCoord.xy-resolution*.5)/resolution.x*4.;
	
	vec2 na = vec2(cos(time),sin(time));
	
	n = vec2(n.x*na.x-n.y*na.y,n.x*na.y+n.y*na.x);
	n *= exp(sin(time*.7))*15.;
	n /= dot(n,n);
	n += vec2(-.2-mouse.x*.1,0);
	
	
	float l = length(n);
	n = vec2(sqrt((l+n.x)*.5),sqrt((l-n.x)*.5)*sign(n.y));
	
	
	vec2 p = vec2(2,0);
	
	float m = dot(p,p);
	for(int i=0; i<MAXITER; i++) {
		p = vec2(p.x*n.x-p.y*n.y,p.x*n.y+p.y*n.x);
		p += vec2(p.x,-p.y)/dot(p,p);
		m = max(m,dot(p,p));
	}
	
	vec3 cb = vec3(100.,30.,10.)*1.;
	vec3 color = cb/(cb+sqrt(m));
	
	gl_FragColor = vec4( 1.-color, 1.0 );

}