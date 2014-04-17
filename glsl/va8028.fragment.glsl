#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 resolution;
uniform float time;

vec2 rand(vec2 pos)
{
	return fract((pow(pos+2.0, pos.yx + 1.0) * 22222.0));
}
vec2 rand2(vec2 pos)
{
	return rand(rand(pos));
}

float softnoise(vec2 pos, float scale)
{
	vec2 smplpos = pos * scale;
	float c0 = rand2((floor(smplpos) + vec2(0.0, 0.0)) / scale).x;
	float c1 = rand2((floor(smplpos) + vec2(1.0, 0.0)) / scale).x;
	float c2 = rand2((floor(smplpos) + vec2(0.0, 1.0)) / scale).x;
	float c3 = rand2((floor(smplpos) + vec2(1.0, 1.0)) / scale).x;
	
	vec2 a = fract(smplpos);
	return mix(
		mix(c0, c1, smoothstep(0.0, 1.0, a.x)),
		mix(c2, c3, smoothstep(0.0, 1.0, a.x)),
		smoothstep(0.0, 1.0, a.y));
}

void main(void)
{
	vec2 pos = gl_FragCoord.xy  / resolution.y;
	//pos *= 5.;
	//pos -= 2.;
	
	float color = 0.0;
	float s = 1.0;
	for(int i = 0; i < 6; i++)
	{
		float noise = softnoise(pos+vec2(i)*0.02,  s * 4.0) / s / 3.0;
		float noise2 = (noise - 0.9/float((i+1)*5))*5.;
		noise2 = clamp(noise2,0.0,1.0);
		float noise3 = abs(noise2 - 0.1)/3.;
		noise3 = clamp(noise3,0.0,1.0);
		color += noise3;
		s *= 2.0;
	}
	gl_FragColor = vec4(color*0.1,color*0.8,color*0.9,1.0);
}