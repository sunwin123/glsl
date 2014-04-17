#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


// By Josh Kasten 10/19/13 (Credit goes to the parent link above but lots of modifications from the orginal.)
// Try moving your mouse to each corner of the screen!

void main( void ) {
	vec2 pos = gl_FragCoord.xy / resolution;
	float amnt, nd;
	vec4 cbuff;

	for(float i=0.0; i<5.0; i+=2.0) {
		nd =sin(3.14*0.8*pos.x + (i*0.1+cos(+time)*0.4) + time);
		amnt = 2.0/abs(nd-pos.y)*0.05; 
		cbuff += vec4(amnt, amnt*0.2 , amnt*pos.y, 1.0);
	}
	


	gl_FragColor = cbuff ;
}