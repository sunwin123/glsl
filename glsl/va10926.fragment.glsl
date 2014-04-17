#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 resolution;
uniform vec2 mouse;                                                                         
vec2 conj(vec2 v){return vec2(v.x,-v.y);}
vec2 inv(vec2 v){return conj(v)/dot(v,v);}
vec2 mu(vec2 u,vec2 v){return vec2( u.x*v.x-u.y*v.y,u.x*v.y+u.y*v.x);}
vec2 fonc(vec2 p,float t){return inv(p-0.1*cos(t))*(2.0+cos(t))+ inv(p+0.5*cos(t))*(2.0+tan(t));}

const float a=3.0;
const float b=5.28;
void main(void)
{    
 vec2 p =8.0 *( gl_FragCoord.xy / resolution.xy)- 4.0 ;
 	p.x*=resolution.x/resolution.y;
 	float tempo=(sin(time*0.1-0.57)+5561.0)*(b-a)/2.0+a;	
 	for(int i=0;i<6;i++){
 	 p=fonc(mu(p,p)+p*(time/(512.0)),tempo*(time/(4096.0*40.0)));}
 	gl_FragColor =vec4(exp(sin(p.x)+cos(p.y)),tan(cos(1./(p.y+p.x))),p.x+p.y,1.);

}