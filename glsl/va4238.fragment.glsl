#ifdef GL_ES
precision highp float;
#endif

uniform vec2 resolution;
uniform float time;
uniform vec2 mouse;

vec3 c;

vec4 obj1(in vec3 p) {
	
	vec3 w = vec3(p);
	
	vec3 d;
	float l;
	for(int k=0; k<10; k++) {
		float nx = w.x * w.x - w.y * w.y - w.z * w.z;
		float ny = 2.0 * w.x * w.y;
		float nz = 2.0 * w.x * w.z;
		w = vec3(nx, ny, nz);
		w = w + c;			
		d = p - w;
		l = length(d);	
		if (l <= 1.0)
			return vec4(l, w.x*w.y, w.y*w.z, w.z*w.x);
	}
	
	return vec4(l,0,0,0);
}
 

//Scene End

void main(void){
  c = vec3(-0.78, 0.15, 0.07);
  c.x += (mouse.x-0.5)*1.0;
  c.z += (mouse.y-0.5)*3.0;
  vec2 vPos=-1.0+2.0*gl_FragCoord.xy/resolution.xy;
  vec3 vuv=vec3(0,1,0);//Change camere up vector here
  vec3 vrp=vec3(0,0,0); //Change camere view here
  float t = time*0.5;
  vec3 prp=vec3(-sin(t)*1.0, 0.0, cos(t)*1.0); //Change camera path position here
  prp *= 2.0;
  vec3 vpn=normalize(vrp-prp);
  vec3 u=normalize(cross(vuv,vpn));
  vec3 v=cross(vpn,u);
  vec3 vcv=(prp+vpn);
  vec3 scrCoord=vcv+vPos.x*u*resolution.x/resolution.y+vPos.y*v;
  vec3 scp=normalize(scrCoord-prp);
  const float maxd=160.0; //Max depth
  vec4 s=vec4(9,0,0,0);
  vec3 c,p,n;
  float f=0.5;
  for(int i=0;i<100;i++){
  	  p = prp + scp * f;
	  s = obj1(p);
	  if (s.x<=1.0) break;
	  f += 0.03;
	  if (f>maxd) break;
  }
  if (f<maxd){
    float b = 1.5 - f/7.0;
	  vec3 n = vec3(s.y,s.z,s.w);
	  b *= 0.5+dot(n, normalize(prp));
    gl_FragColor=vec4(0.7,0.85,1.0,1.0)*b;	  
  }
  else gl_FragColor=vec4(0,0,0,1); //background color
}