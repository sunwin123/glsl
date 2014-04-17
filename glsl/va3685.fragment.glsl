#ifdef GL_ES
precision mediump float;
#endif
//tigrou (ind) 2012.08.22, based on http://pouet.net/prod.php?which=59786
//forked by psonice
uniform float time;
uniform vec2 resolution;

void main( void ) 
{
   vec2 p = ( (gl_FragCoord.xy-resolution.xy/5.0) / min(resolution.x, resolution.y))*6.0;
	
   float c = abs(p.x+p.y)+abs(p.x-p.y)+atan(p.y + sin(time *.55)*10.,p.x + sin(time*.76)*10.) * 6.-float((time*8.0)*2.);
   
   c = abs(sin(c))*sign(sin(c))+1.0;	
   if (c < 0.4) c = 0.0;
   else if (c > 0.2 && c < 1.7) c = float(int((sin(c*1115.0)+1.0)));
   else c = 67.0;
	   
   gl_FragColor = vec4(c * 0.7, 0.0,0.0, 67.0 );

}