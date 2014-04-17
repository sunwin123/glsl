#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
#define PI 3.14159
#define ITER 24.

//quickie with fourier series, nothing cool here, sorry. 
//saw wave :D
void main( void ) {

	vec2 pos = ( gl_FragCoord.xy / resolution.xy );
	pos-=vec2(0.5,0.5);
	pos*=4.;
	vec3 color;
	//color.r=abs(pos.x);
	//color.g=abs(pos.y);
	float f=0.;
	float iter=5.;
	for(float i=0.;i<ITER;i++){
		f+=sin((0.75*i+0.)*PI*(pos.x-time*1.))/(2.*i+1.);
	}
	f=atan(f*abs(sin(time)+1.0)*512.0)/2.0; // very cool - sigmoid clip to square wave
	float d=pos.y-f;
	
	if(d>-0.025&&d<0.025){
		color=vec3(1.,1,0);
	}
	
	gl_FragColor = vec4(color, 1.0 );
}