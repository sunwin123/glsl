///@ME
//Wanna see more nice HQ patterns here!

// rotwang @mod* very nice!
// ME @mod* 

#ifdef GL_ES
precision lowp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform vec2 reyboard;

const float PI = 3.1415926535;
const float TWOPI = PI*2.0;

float unsin(float t)
{
	return sin(t)*0.5+0.5;
}

float curve( float x)
{
	return smoothstep( 0.5, 0.5,sin(x*PI) ) - sin(x*PI)+0.5;
}

float thing(vec2 pos) 
{
	float ret = 0.;
	
	float a = curve(pos.x);
	float b = curve(pos.y);
	return (a + b)* (sqrt(a*b)*10.0);
}

void main(void) 
{
	vec2 position = ( gl_FragCoord.xy / resolution );
	vec2 world = position * 10.0;
	world.x *= resolution.x / resolution.y;
	float dist = 1./thing(world);

	gl_FragColor = vec4( dist, dist, dist, 1.0 );
}
