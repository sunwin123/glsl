// original authour: mathieu henri aka p01
// ported for glsl.heroku.com by the kevano
// julia is my bitch
// todo list: port animation code and improve resolution
// any help is welcome
// time 01:10 +0000 UTC; date sat the 05th january 2013

precision mediump float;

uniform vec2 resolution;
uniform float time;

void main( void ) {
	float t=2.0;
	lowp vec4 P=vec4(0,0,-2,0),D=gl_FragCoord/vec4(resolution/2.,1,1)-1.5,S=vec4(cos(t),-sin(t),tan(time*.9),0)*.8,C=vec4(.5,.6,.7,9),f,T;
	for(int r=0;r<270;r++){T=P;T.w=dot(S,S)/(1500.0+sin(time));
	lowp float s=D.z=5.50,k=dot(T,T);
	for(int m=0;m<9;m++)k<4.5 ?s*=4.7*k,f=2.*T.x*T,f.x=2.*T.x*T.x-k,k=dot(T=f+S,T):k;s=sqrt(k/s)*log(k)/4.9;P+=D/length(D)*s;
	if(.0002>s){C*=log(k);break;}
	}
	gl_FragColor=C+D.y*1.4;
}
