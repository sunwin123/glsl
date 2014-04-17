#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform sampler2D backbuffer;
float PI = 3.141;

void main( void ) {

	vec2 position = ( gl_FragCoord.xy / resolution.xy );
        float m1 = 20.0*(mouse.y-0.5);
	float m2 = 20.0*(mouse.x-0.5);
	float t1 = sin(PI*position.x+m2)*cos(PI*position.y+m1);
	float c1 = t1/m1*10.0;
	float c2 = t1/m2*10.0;
	float cc = 1.5;
	vec4 bgcol = texture2D(backbuffer, vec2(mod(pow(cos(t1)*position.x*m1-c1, 2.0)+
						    pow(sin(t1)*position.y*m2-c2, 2.0), 0.5)+mod(time*cc, 0.5),
						    0.999));
	// do some rgb fuckup and tv-effect
	bgcol.x += 0.5*(sin(position.x*PI*2.0-1.5+cos(position.y*1000.0*mouse.y)*sin(position.y+time*4.5)));
	bgcol.y += 0.5*(sin(position.x*PI*2.0-1.5+cos(position.y*100.0*mouse.x)*sin(position.y+time*2.5)));
	bgcol.z += 0.5*(sin(position.y*PI*2.0-1.5+sin(position.x*10.0*mouse.x)*sin(position.y+time*1.5)));
	bgcol = bgcol * mod(gl_FragCoord.y, 2.0);	

	// create palette to top part of screen for color cycling
	if (position.y > 0.992) {
		bgcol = vec4(clamp(abs(cos(position.x*2.0*PI-mouse.y)), 0.0, 1.0),
			     clamp(abs(cos(position.x*2.0*PI-mouse.x*0.01)), 0.0, 1.0),
			     clamp(abs(cos(position.x*2.0*PI+mouse.x)), 0.0, 1.0), 1.0);
	}
	gl_FragColor = bgcol;
}