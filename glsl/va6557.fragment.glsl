#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

vec3 lookupCol(float f)
{
	return vec3(f, f/1.5, f/3.0);
}

void main( void ) {
	vec2 p = gl_FragCoord.xy;
	p = -1.0 + 2.0 * p / resolution.xy;
	p.x -= 0.5;	
	
	float aa = -2.24;
	float bb = -1.65;
	float cc = 0.43;
	float dd = -2.43;
	
	vec4 insideColor = vec4(0.1, 0.7, 0.9, 1.0);
	vec2 c = p;
	vec2 z = vec2(0.0, 0.0);
	const float maxIterations = 70.0;
	gl_FragColor = insideColor;
	for (float i = 0.0; i < maxIterations; i += 1.0)
	{
		// Z(n+1) = Z(n)^2 + c;
		// Using the FOIL method
		z = vec2(z.x*z.x - z.y*z.y, 2.0*z.x*z.y) + c;
		//z = vec2(sin(aa*z.y*z.x) - cos(bb*z.x), sin(cc*z.x) - cos(dd*z.y));
		
		if (dot(z, z) > 4.0)
		{
			gl_FragColor = vec4(lookupCol(i / maxIterations), 1.0);
			break;
		}
	}
}