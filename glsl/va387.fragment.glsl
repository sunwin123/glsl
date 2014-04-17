// By @paulofalcao
//
// Blobs
// messed with by @danbri to figure out how it works

#ifdef GL_ES
precision highp float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float makePoint(float x,float y,float fx,float fy,float sx,float sy,float t){
   float xx=x+sin(t*fx)*sx;
   float yy=y+sin(t*fy)*sy;
   return 7./sqrt(xx*xx+yy*yy); // 4 is super blurry; 1.5 is only slightly
}

void main( void ) {

   vec2 p=(gl_FragCoord.xy/resolution.x)*2.0-vec2(1.0,resolution.y/resolution.x);

   float x=p.x;
   float y=p.y;

   float a=  makePoint(x,y,.1,.1,.1,.3,time); // red
  /* a=a+makePoint(x,y,1.9,2.0,0.4,0.4,time);
  a=a+makePoint(x,y,0.8,0.7,0.4,0.5,time);
  a=a+makePoint(x,y,2.3,0.1,0.6,0.3,time);
   a=a+makePoint(x,y,0.8,1.7,0.5,0.4,time);
   a=a+makePoint(x,y,0.3,1.0,0.4,0.4,time);
   a=a+makePoint(x,y,1.4,1.7,0.4,0.5,time);
   a=a+makePoint(x,y,1.3,2.1,0.6,0.3,time);
   a=a+makePoint(x,y,1.8,1.7,0.5,0.4,time);   
   */
 
  float b= makePoint(x,y,.1,.1,.3,.3,time); // green
  b=b+makePoint(x,y,.7,.7,.4,.4,time);
/*   b=b+makePoint(x,y,1.4,0.6,0.4,0.5,time);
   b=b+makePoint(x,y,2.6,0.4,0.6,0.3,time);
   b=b+makePoint(x,y,0.7,1.4,0.5,0.4,time);
   b=b+makePoint(x,y,0.7,1.7,0.4,0.4,time);
   b=b+makePoint(x,y,0.8,0.5,0.4,0.5,time);
   b=b+makePoint(x,y,1.4,0.9,0.6,0.3,time);
   b=b+makePoint(x,y,0.7,1.3,0.5,0.4,time); */

   float c=       makePoint(x,y,1.7,1.3,1.3,0.3,time); // blue
/*   c=c+makePoint(x,y,1.9,1.3,0.4,0.4,time);
   c=c+makePoint(x,y,0.8,0.9,0.4,0.5,time);
   c=c+makePoint(x,y,1.2,1.7,0.6,0.3,time);
   c=c+makePoint(x,y,0.3,0.6,0.5,0.4,time);
   c=c+makePoint(x,y,0.3,0.3,0.4,0.4,time);
   c=c+makePoint(x,y,1.4,0.8,0.4,0.5,time);
   c=c+makePoint(x,y,0.2,0.6,0.6,0.3,time);
   c=c+makePoint(x,y,1.3,0.5,0.5,0.4,time); */
   
   gl_FragColor = vec4(a/64.,b/32.,c/32.,1.0);
}