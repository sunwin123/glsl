#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

uniform float xsc, ysc;

void main ()
{
   float x, y, dx, dy, cx, cy, rr, e, vx, vy, d, a, f, a2, xx, yy, rd;
   float PI=3.14159265358979323;

   x = gl_FragCoord.x*(.001+cos(time*1.0)*.0001)+cos(time*1.0)*.25;
   y = gl_FragCoord.y*(.001+sin(time*1.0)*.0001)-sin(time*1.0)*.25;
   //based on: http://traipse.com/poster/index.html
   y = 1.0-y; dx = x; dy = y;
   cx = .5; cy = .7; rr = .6; e = 3.0;
   vx = x-cx; vy = y-cy;
   d = sqrt(vx*vx + vy*vy);
   if (d > 0.0)
   {
      rd = 1.0/d; vx *= rd; vy *= rd;
      d /= rr; d = d*d*d*rr;
      x = vx*d + cx;
      y = vy*d + cy;
   }
   a = 0.1; a2 = PI/a;
   f  = cos(sqrt((dx-.4)*(dx-.4) + (dy-.4)*(dy-.4))*a2)*0.5 + 0.5;
   f += cos(sqrt((dx-.8)*(dx-.8) + (dy-.1)*(dy-.1))*a2)*0.5 + 0.5;
   f += cos(sqrt((dx-.9)*(dx-.9) + (dy-.3)*(dy-.3))*a2)*0.5 + 0.5;
   f += cos(sqrt((dx-.3)*(dx-.3) + (dy-.8)*(dy-.8))*a2)*0.5 + 0.5;
   f += cos(sqrt((dx-.7)*(dx-.7) + (dy-.1)*(dy-.1))*a2)*0.5 + 0.5;
   f += cos(sqrt((dx-.4)*(dx-.4) + (dy-.5)*(dy-.5))*a2)*0.5 + 0.5;
   f /= 6.0;
   
   a *= (1.0-1.0/exp(max(sqrt((dx-.5)*(dx-.5) + (dy-.7)*(dy-.7))/.4 - 1.0,0.0)));
   if (a > 0.0)
   { x += cos(f*(2.0*PI*2.0))*a;
     y += sin(f*(2.0*PI*2.0))*a;
   }
       
   a = 0.01; a2 = PI/a;
   f  = cos(sqrt((x-.2)*(x-.2) + (y-.4)*(y-.4))*a2)*0.5 + 0.5;
   f += cos(sqrt((x-.4)*(x-.4) + (y-.2)*(y-.2))*a2)*0.5 + 0.5;
   f += cos(sqrt((x-.6)*(x-.6) + (y-.8)*(y-.8))*a2)*0.5 + 0.5;
   f += cos(sqrt((x-.1)*(x-.1) + (y-.2)*(y-.2))*a2)*0.5 + 0.5;
   f += cos(sqrt((x-.9)*(x-.9) + (y-.2)*(y-.2))*a2)*0.5 + 0.5;
   f += cos(sqrt((x-.2)*(x-.2) + (y-.3)*(y-.3))*a2)*0.5 + 0.5;
   f /= 6.0;
    
   a2 = f*(2.0*PI*2.0);
   x += cos(a2)*a;
   y += sin(a2)*a;
       
   xx = x-.5; yy = y-.7;
   f = atan(-xx/yy)-PI*.5+float(yy>=0.0)*PI; //f = atan2(yy,xx);
   f = (cos((f + 12.0*sqrt(xx*xx + yy*yy))*3.0)/2.0+.5);
   f = pow(f,.7);
   
   f *= (256.0-256.0/exp(max(sqrt((x-.5)*(x-.5) + (y-.7)*(y-.7))/.005 - 1.0,0.0)));
   gl_FragColor = vec4(f/256.0,f/256.0,f/256.0,0); //r = f; g = f; b = f;
}