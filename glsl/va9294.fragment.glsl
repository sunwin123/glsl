// fuck that shit.

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;

// NEBULA - CoffeeBreakStudios.com (CBS)
// Work in progress...
//
// 3148.26: Switched from classic to simplex noise
// 3148.27: Reduced number of stars
// 3249.0:  Switched to fast computed 3D noise. Less quality but ~ 2x faster
// 3249.5:  Removed use of random number generator to gain performance
// 3265.0:  Added rotation: glsl.heroku.com/e#3005.1
// 3265.4:  Added small stars in background: http://glsl.heroku.com/e#2927.2
// 3265.6:  Faster random number generator

//Utility functions

vec3 fade(vec3 t) {
  return vec3(1.0,1.0,1.0);
}

vec4 randomizer4(const vec4 x)
{
    vec4 z = mod(x, vec4(5612.0));
    z = mod(z, vec4(3.1415927 * 2.0));
    return(fract(cos(z) * vec4(56812.5453)));
}

float rand(vec2 co){
    return fract(sin(dot(co.xy ,vec2(12.9898,78.233))) * 43758.5453);
}

// Fast computed noise
// http://www.gamedev.net/topic/502913-fast-computed-noise/

const float A = 1.0;
const float B = 57.0;
const float C = 113.0;
const vec3 ABC = vec3(A, B, C);
const vec4 A3 = vec4(0, B, C, C+B);
const vec4 A4 = vec4(A, A+B, C+A, C+A+B);

float cnoise4(const in vec3 xx)
{
    vec3 x = mod(xx + 32768.0, 65536.0);
    vec3 ix = floor(x);
    vec3 fx = fract(x);
    vec3 wx = fx*fx*(3.0-2.0*fx);
    float nn = dot(ix, ABC);

    vec4 N1 = nn + A3;
    vec4 N2 = nn + A4;
    vec4 R1 = randomizer4(N1);
    vec4 R2 = randomizer4(N2);
    vec4 R = mix(R1, R2, wx.x);
    float re = mix(mix(R.x, R.y, wx.y), mix(R.z, R.w, wx.y), wx.z);

    return 1.0 - 2.0 * re;
}
float surface3 ( vec3 coord, float frequency ) {
	
	float n = 0.0;	
		
	n += 1.0	* abs( cnoise4( coord * frequency ) );
	n += 0.5	* abs( cnoise4( coord * frequency * 2.0 ) );
	n += 0.25	* abs( cnoise4( coord * frequency * 4.0 ) );
	n += 0.125	* abs( cnoise4( coord * frequency * 8.0 ) );
	n += 0.0625	* abs( cnoise4( coord * frequency * 16.0 ) );
	
	return n;
}
	
void main( void ) {

	vec2 position = gl_FragCoord.xy / resolution.xy;
	float delta = time*0.01;
	delta += sin(time*0.021)*10.0+15.0;
	delta += sin(time*0.030)*32.0+13.0;
	delta += sin(time*0.046)*24.0+11.0;
	delta += sin(time*0.033)*16.0+20.0;
	delta += sin(time*0.037)* 8.0+17.0;
	
	float n = surface3(vec3(position*sin(delta*0.1), delta * 0.05)*mat3(1,sin(1.0),0,0,.8,.6,0,-.6,.8),0.9);
	float n2 = surface3(vec3(position*cos(delta*0.1), delta * 0.04)*mat3(1,cos(1.0),0,0,.8,.6,0,-.6,.8),0.8);
    	float lum = length(n);
    	float lum2 = length(n2);

	vec3 tc = pow(vec3(1.3-lum),vec3(sin(position.x)+cos(delta)+4.0,8.0+sin(delta)+4.0,8.0));
	vec3 tc2 = pow(vec3(1.1-lum2),vec3(5.0,position.y+cos(delta)+7.0,sin(position.x)+sin(delta)+2.0));
	vec3 curr_color = (tc*1.8*0.5) + (tc2*1.1*0.5);
	
	curr_color.r *= 0.55;
	curr_color.r *= mod(gl_FragCoord.y, 2.0);
	curr_color.g *= curr_color.b*0.5;

	gl_FragColor = vec4(curr_color*0.5, 1.0);
}