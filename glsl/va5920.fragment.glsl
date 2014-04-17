#ifdef GL_ES
precision mediump float;
#endif

// Tweaked version of http://glsl.heroku.com/e#5068
// Posted by Trisomie21

uniform float time;
varying vec2 surfacePosition;

const float Tau = 6.2831853;

//
// Description : Array and textureless GLSL 2D/3D/4D 
//               noise functions with wrapping
//      Author : People
//  Maintainer : Anyone
//     Lastmod : 20120109 (Trisomie21)
//     License : No Copyright No rights reserved.
//               Freely distributed
//
float snoise(vec3 uv, float res)
{
	const vec3 s = vec3(1e0, 1e2, 1e4);
	
	uv *= res;
	
	vec3 uv0 = floor(mod(uv, res))*s;
	vec3 uv1 = floor(mod(uv+vec3(1.), res))*s;
	
	vec3 f = fract(uv);
	f = f*f*(3.0-2.0*f);

	vec4 v = vec4(uv0.x+uv0.y+uv0.z, uv1.x+uv0.y+uv0.z,
		      uv0.x+uv1.y+uv0.z, uv1.x+uv1.y+uv0.z);

	vec4 r = fract(sin(v*1e-3)*1e5);
	float r0 = mix(mix(r.x, r.y, f.x), mix(r.z, r.w, f.x), f.y);
	
	r = fract(sin((v + uv1.z - uv0.z)*1e-3)*1e5);
	float r1 = mix(mix(r.x, r.y, f.x), mix(r.z, r.w, f.x), f.y);
	
	return mix(r0, r1, f.z)*2.-1.;
}

// http://www.noisemachine.com/talk1/24a.html
void main(void) 
{
	vec2 p = surfacePosition;
	float d = length(p);
	
	if(d<0.25) return;
	
	float a = clamp((d-.25)*100., 0., 1.);
	
	float power = 1.;
	float color = 3.0 - (3.*length(2.*p));
	
	vec3 coord = vec3(atan(p.x,p.y)/Tau+.5, d*.4, .5);
	coord += vec3(0.,-time*.01, time*.002);
	
	for(int i = 0; i < 7; i++)
	{
		power *= 2.;
		color += (1.5 / power) * snoise(coord, power*12.);
	}

	gl_FragColor = vec4( color, pow(max(color,0.),2.)*0.4, pow(max(color,0.),3.)*0.15 , 1.0)*a;
}