#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

// GLSL implementation of 2D "flow noise" as presented
// by Ken Perlin and Fabrice Neyret at Siggraph 2001.
// (2D simplex noise with analytic derivatives and
// in-plane rotation of generating gradients,
// in a fractal sum where higher frequencies are
// displaced (advected) by lower frequencies in the
// direction of their gradient. For details, please
// refer to the 2001 paper "Flow Noise" by Perlin and Neyret.)
//
// Author: Stefan Gustavson (stefan.gustavson@liu.se)
// Distributed under the terms of the MIT license.
// See LICENSE file for details.
// 
//changes by George Toledo, 2011, setting it up for QC.....and 2012. Setting it up for webgl.
//varying vec2 vTexCoord2D;
//uniform float time;

//
//uniform float gradient_weight_1;
//uniform float gradient_weight_2;
//uniform float gradient_xvec;
//uniform float gradient_yvec;

//uniform float red;
//uniform float green;
//uniform float blue;
//uniform float alpha;

// Helper constants
#define F2 0.366025403
#define G2 0.211324865
#define K .0243902439 // 1/41

// Permutation polynomial
float permute(float x) {
  return mod((34.0 * x + 1.)*x, 289.0);
}

// Gradient mapping with an extra rotation.
vec2 grad2(vec2 p, float rot) {
#if 1
// Map from a line to a diamond such that a shift maps to a rotation.
  float u = permute(permute(p.x) + p.y) * K + rot; // Rotate by shift
  u = 4.0 * fract(u) - 2.0;
  return vec2(abs(u)-1.0, abs(abs(u+1.0)-2.0)-1.0);
#else
#define TWOPI 6.28318530718
// For more isotropic gradients, sin/cos can be used instead.
  float u = permute(permute(p.x) + p.y) * K + rot; // Rotate by shift
  u = fract(u) * TWOPI;
  return vec2(cos(u), sin(u));
#endif
}

float srdnoise(in vec2 P, in float rot, out vec2 grad) {

  // Transform input point to the skewed simplex grid
  vec2 Ps = P + dot(P, vec2(F2));

  // Round down to simplex origin
  vec2 Pi = floor(Ps);

  // Transform simplex origin back to (x,y) system
  vec2 P0 = Pi - dot(Pi, vec2(G2));

  // Find (x,y) offsets from simplex origin to first corner
  vec2 v0 = P - P0;

  // Pick (+x, +y) or (+y, +x) increment sequence
  vec2 i1 = (v0.x > v0.y) ? vec2(1.0, 0.0) : vec2 (0.0, 1.0);

  // Determine the offsets for the other two corners
  vec2 v1 = v0 - i1 + G2;
  vec2 v2 = v0 - 1.0 + 2.0 * G2;

  // Wrap coordinates at 289 to avoid float precision problems
  Pi = mod(Pi, 289.0);

  // Calculate the circularly symmetric part of each noise wiggle
  vec3 t = max(0.5 - vec3(dot(v0,v0), dot(v1,v1), dot(v2,v2)), 0.0);
  vec3 t2 = t*t;
  vec3 t4 = t2*t2;

  // Calculate the gradients for the three corners
  vec2 g0 = grad2(Pi, rot);
  vec2 g1 = grad2(Pi + i1, rot);
  vec2 g2 = grad2(Pi + 1.0, rot);

  // Compute noise contributions from each corner
  vec3 gv = vec3(dot(g0,v0), dot(g1,v1), dot(g2,v2)); // ramp: g dot v
  vec3 n = t4 * gv;  // Circular kernel times linear ramp

  // Compute partial derivatives in x and y
  vec3 temp = t2 * t * gv;
  vec3 gradx = temp * vec3(v0.x, v1.x, v2.x);
  vec3 grady = temp * vec3(v0.y, v1.y, v2.y);

  grad.x = -8. * (gradx.x + gradx.y + gradx.z);
  grad.y = -8. * (grady.x + grady.y + grady.z);
  grad.x += dot(t4, vec3(g0.x, g1.x, g2.x));
  grad.y += dot(t4, vec3(g0.y, g1.y, g2.y));

  grad *= 40.;
  // Add contributions from the three corners and return

  return 40. * (n.x + n.y + n.z);
}

void main(void) {
  	vec2 g1, g2;
//  vec2 p = vTexCoord2D;
	vec2 p = ( gl_FragCoord.xy - (mouse*resolution.x))/80.*(sin(time*.15)+2.);
  	float n1 = srdnoise(p*0.5, 0.2*time, g1);
  	float n2 = srdnoise(p*2.0 + g1*0.5, 0.51*time, g2);
  	float n3 = srdnoise(p*4.0 + g1*0.5 + g2*.25, 0.77*time, g2);
  	gl_FragColor = vec4(vec3(.9, 0.3, 0.01) + vec3(n1+.95*n2+.75*n3), 1.);
	//gl_FragColor = (vec4(n1,n2,n3, 1.));
	//gl_FragColor -=.5;
}
