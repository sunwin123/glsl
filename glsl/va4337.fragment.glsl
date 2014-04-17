//MG
#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;

void main() {
	vec2 p=(gl_FragCoord.xy/resolution.y)*10.0;
	p.x-=resolution.x/resolution.y*5.0;p.y-=5.0;
	float dist,fx;
	vec2 q=gl_FragCoord.xy/resolution.xy;
	
	vec4 col=texture2D(backbuffer,q);
	gl_FragColor=col/1.1;
	
	fx=sin(p.x+time*1.5);
	dist=0.005/abs(fx-p.y);
	gl_FragColor+=vec4(dist,dist,4.0*dist,1.0);
	
	fx=cos(p.x+time)*2.0;
	dist=0.005/abs(fx-p.y);
	gl_FragColor+=vec4(4.0*dist,dist,dist,1.0);
}