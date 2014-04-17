#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
float count = 0.0;

void main( void ) {
	vec3 color = vec3(0,0,0);
	float sq = 32.0;
	
	vec2 pos = mouse * resolution;
	
	//for(float i = 0.0; i < 100.0; i+=1.0) {
	
	pos.x = sq * ((pos.x / sq)-fract(pos.x / sq));
	pos.y = sq * ((pos.y / sq)-fract(pos.y / sq));	
	
	pos.x = count;
	
	if (   gl_FragCoord.x > pos.x - sq/2.0
	    && gl_FragCoord.x < pos.x + sq/2.0
	    && gl_FragCoord.y < pos.y + sq/2.0
	    && gl_FragCoord.y > pos.y - sq/2.0) color = vec3(1,1,1);
	
	gl_FragColor = vec4(color, 1.0 );
	
	//}
	
	count = count + 100.0;
}