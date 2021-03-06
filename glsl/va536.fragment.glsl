#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

// Cellular noise ("Worley noise") in 2D in GLSL.
// Copyright (c) Stefan Gustavson 2011-04-19. All rights reserved.
// This code is released under the conditions of the MIT license.
// See LICENSE file for details, located in ZIP file here:
// http://webstaff.itn.liu.se/~stegu/GLSL-cellular/

// Permutation polynomial: (34x^2 + x) mod 289
vec3 permute(vec3 x) {
  return mod((34.0 * x + 1.0) * x, 289.0);
}

// Cellular noise, returning F1 and F2 in a vec2.
// Standard 3x3 search window for good F1 and F2 values
vec2 cellular(vec2 P) {
#define K 0.142857142857 // 1/7
#define Ko 0.428571428571 // 3/7
#define jitter 1.0 // Less gives more regular pattern
	vec2 Pi = mod(floor(P), 289.0);
 	vec2 Pf = fract(P);
	vec3 oi = vec3(-1.0, 0.0, 1.0);
	vec3 of = vec3(-0.5, 0.5, 1.5);
	vec3 px = permute(Pi.x + oi);
	vec3 p = permute(px.x + Pi.y + oi); // p11, p12, p13
	vec3 ox = fract(p*K) - Ko;
	vec3 oy = mod(floor(p*K),7.0)*K - Ko;
	vec3 dx = Pf.x + 0.5 + jitter*ox;
	vec3 dy = Pf.y - of + jitter*oy;
	vec3 d1 = dx * dx + dy * dy; // d11, d12 and d13, squared
	p = permute(px.y + Pi.y + oi); // p21, p22, p23
	ox = fract(p*K) - Ko;
	oy = mod(floor(p*K),7.0)*K - Ko;
	dx = Pf.x - 0.5 + jitter*ox;
	dy = Pf.y - of + jitter*oy;
	vec3 d2 = dx * dx + dy * dy; // d21, d22 and d23, squared
	p = permute(px.z + Pi.y + oi); // p31, p32, p33
	ox = fract(p*K) - Ko;
	oy = mod(floor(p*K),7.0)*K - Ko;
	dx = Pf.x - 1.5 + jitter*ox;
	dy = Pf.y - of + jitter*oy;
	vec3 d3 = dx * dx + dy * dy; // d31, d32 and d33, squared
	// Sort out the two smallest distances (F1, F2)
	vec3 d1a = min(d1, d2);
	d2 = max(d1, d2); // Swap to keep candidates for F2
	d2 = min(d2, d3); // neither F1 nor F2 are now in d3
	d1 = min(d1a, d2); // F1 is now in d1
	d2 = max(d1a, d2); // Swap to keep candidates for F2
	d1.xy = (d1.x < d1.y) ? d1.xy : d1.yx; // Swap if smaller
	d1.xz = (d1.x < d1.z) ? d1.xz : d1.zx; // F1 is in d1.x
	d1.yz = min(d1.yz, d2.yz); // F2 is now not in d2.yz
	d1.y = min(d1.y, d1.z); // nor in  d1.z
	d1.y = min(d1.y, d2.x); // F2 is in d1.y, we're done.
	return sqrt(d1.xy);
}

float noisy(vec2 pos) {
	// poofy fractal-noise(ish) clouds
  	float x = pos.x;
  	float y = pos.y;
	float val = 0.0;
	for (float i=0.0; i<4.0; i++) {
		float ang = pow((i + 2.53) * 7.15, 2.5);
		float scale = 4.0 + i * i * 0.3;
		val += sin((x - i * 15.0) * sin(ang) * scale - (y + i * 10.0) * cos(ang) * scale) / (i + 3.0);
	}
	return val;
}

void main( void ) {
	vec2 position = ( gl_FragCoord.xy / resolution.xy );
	position -= 0.5;
  	position *= 1.5 * pow(length(position), -1.6);
  	position += 0.5;

	position += vec2(time * 0.6, time * 0.2);
  	position += vec2(noisy(vec2(position.x * 0.1, position.y * 40.0)), 0.0) * 0.04;

	vec2 F = cellular(position);
	float facets = 0.1+(F.y-F.x);
	float dots = smoothstep(0.05, 0.1, F.x);
	float n = facets * dots;
  
  	vec3 bkg = vec3(0.7, 0.5, 0.3);
  	vec3 fill = vec3(0.5, 0.3, 0.1);
  
	//gl_FragColor = vec4(1.0 - dots, max(1.0 - dots, facets * 0.5), n, 1.0);
  	float border = clamp((abs(facets - 0.4) - 0.11 - noisy(position * 2.6) * 0.3) * 15.0, 0.0, 1.0);
  	float filler = clamp((facets - 0.3) * 6.0, 0.0, 1.0);

  	gl_FragColor.rgb = (bkg * (1.0 - filler) + fill * filler) * dots * border;
	gl_FragColor.a = 1.0;
}