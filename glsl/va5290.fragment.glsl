// 00f404afdd835ac3af3602c8943738ea
// see notes in code; please annotate any changes (with source URLs if relevant.)

#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float _MinStep = 0.125;

//////////////////////////////////////////////////////////////
// http://www.gamedev.net/topic/502913-fast-computed-noise/
// replaced costly cos with z^2. fullreset
vec4 random4 (const vec4 x) {
    vec4 z = mod(mod(x, vec4(5612.0)), vec4(3.1415927 * 2.0));
    return fract ((z*z) * vec4(56812.5453));
}
const float A = 1.0;
const float B = 57.0;
const float C = 113.0;
const vec3 ABC = vec3(A, B, C);
const vec4 A3 = vec4(0, B, C, C+B);
const vec4 A4 = vec4(A, A+B, C+A, C+A+B);
float cnoise4 (const in vec3 xx) {
    vec3 x = xx; // mod(xx + 32768.0, 65536.0); // ignore edge issue
    vec3 fx = fract(x);
    vec3 ix = x-fx;
    vec3 wx = fx*fx*(3.0-2.0*fx);
    float nn = dot(ix, ABC);

    vec4 N1 = nn + A3;
    vec4 N2 = nn + A4;
    vec4 R1 = random4(N1);
    vec4 R2 = random4(N2);
    vec4 R = mix(R1, R2, wx.x);
    float re = mix(mix(R.x, R.y, wx.y), mix(R.z, R.w, wx.y), wx.z);

    return 1.0 - 2.0 * re;
}

//////////////////////////////////////////////////////////////
// distance functions
// http://www.iquilezles.org/www/articles/distfunctions/distfunctions.htm
float sdSphere( vec3 p, float s ) { return length(p)-s; }
float udBox( vec3 p, vec3 b ) {  return length(max(abs(p)-b,0.0)); }
float udRoundBox( vec3 p, vec3 b, float r ) { return length(max(abs(p)-b,0.0))-r; }
float sdTorus( vec3 p, vec2 t ) { vec2 q = vec2(length(p.xz)-t.x,p.y);  return length(q)-t.y; }
vec3  opRep(vec3 p, vec3 r) { return mod(p,r)-0.5*r; }
vec3  opTx(vec3 p, mat4 m ) { return (m*vec4(p,1.0)).xyz; }

/////////////////////////////////////////////////////
// the rest

float fbm(vec3 p) {
    float f;
    f = 0.5000*cnoise4( p ); p = p*2.02;
    f += 0.2500*cnoise4( p ); p = p*2.03;
    f += 0.1250*cnoise4( p ); p = p*2.01;
    f += 0.0625*cnoise4( p ); 
  return f;
}

float scene(vec3 p) { 
  p = opRep(p,vec3(18.,1.25,18.)) + fbm(p)*0.8;
  p.y *= sin(time);
  float g = (1.+sin(time*2.0)*0.5);
  float ub = udBox(p,vec3(.25*g*2.0,1.,.25*g*2.0));
  float st = sdTorus(p,vec2(1.5*g,0.20*g));
  return min(ub,st);
}

vec4 color(float d) { 
  return mix(vec4(0.8,0.5,0.,0.03),vec4(0.,0.,0.,0.0),smoothstep(0.2,0.25,d)); 
}

vec4 ray(vec3 pos, vec3 step) {
    vec4 sum = vec4(0.3, 0.1, 0., 0.);
    vec4 col;
    float d;
#define RAY1  d = scene(pos); col = color(d); col.rgb *= (pos.y+.5); col.rgb *= col.a; sum += col*(1.0 - sum.a); pos += step*max(d*0.9,_MinStep);
#define RAY4  RAY1 RAY1 RAY1 RAY1
    RAY4 RAY4 RAY4 RAY4
    return sum;
}

void main( void ) {
  vec3 e = vec3(time,cos(time*0.25)*2.5,time); 
  vec3 p = vec3((gl_FragCoord.xy / resolution.xy) * 2. - 1., 1.);
  p.x *= resolution.x/resolution.y;
  p = e + p;
  gl_FragColor = ray(p, normalize(p-e)+fbm(p.xyx)/50.0);
}