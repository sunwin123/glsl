#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 resolution;
uniform float time;
 
float lengthN(vec2 v, float n)
{
  vec2 tmp = pow(abs(v)*sin(time), vec2(n));
  return pow(tmp.x*tmp.y, 1.0/n);
}
 
float rings(vec2 p)
{
  vec2 p2 = mod(p*15.0, 4.0)-2.0;
  return sin(lengthN(p2, 4.0)*16.0);
}
 
vec2 trans(vec2 p)
{
  float sec;
  sec = time*1.016;
  return vec2(p.x+cos(sec), p.y+sin(sec));
}
 
void main() {
  vec2 pos = (gl_FragCoord.xy*2.0 -resolution) / resolution.y;
 
  gl_FragColor = vec4(rings(trans(pos)),0.2,0.5,0.5);
}