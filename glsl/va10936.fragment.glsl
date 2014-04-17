#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


vec4 checker(in vec2 p){
	p *= 20.0;
	
	if (fract(p.x*.5)>.5)
	if (fract(p.y*.5)>.5)
	return vec4(1,1,1,1);
	else
	return vec4(0,0,0,1);
	else
	if (fract(p.y*.5)>.5)
	return vec4(0,0,0,1);
	else
	return vec4(1,1,1,1);
}

void main( void )
{
	vec2 p = gl_FragCoord.xy / resolution.xy;
	
	vec2 points[3];
	points[0] = vec2(0.2,0.3);
	points[1] = vec2(0.8,0.5);
	points[2] = vec2(0.2,0.7);
	
	
	vec2 off[3];
	off[0] = vec2(0.4, 0.4);
	off[1] = vec2(0.2, 0.05);
	off[2] = vec2(0.32, 0.6);
	
	vec2 o;
	
	float bf = 10.0;
	for(int i = 0; i < 3; i++)
	{
		float d = length(p - points[i]);
		if(d < bf)
		{
			bf = d;
			o = off[i];
		}	
	}
	gl_FragColor = checker(p + o);
	
}