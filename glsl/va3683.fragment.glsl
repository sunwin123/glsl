///////////////////////////////////////////////
//										//
//	Another Color Tech Tunnel	by			//
//					T_S=RTX1911=			//
//										//
//		Kings still playing since 1998 - 2012		//
//										//
//		twitter at	: @rtx1911				//
//				: @T_SDesignWorks			//
//										//
//		www.demoscene.jp					//
//										//
//////////////////////////////////////////////


#ifdef GL_ES
precision mediump float;
#endif

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;
uniform float lowFreq;


vec3 roy(vec3 v, float x)
{
    return vec3(cos(x)*v.x - sin(x)*v.z,v.y,sin(x)*v.x + cos(x)*v.z);
}

vec3 rox(vec3 v, float x)
{
    return vec3(v.x,v.y*cos(x) - v.z*sin(x),v.y*sin(x) + v.z*cos(x));
}

float fdtun(vec3 rd, vec3 ro, float r)
{
	float a = dot(rd.xy,rd.xy);
  	float b = dot(ro.xy,rd.xy);
	float d = (b*b)-(32.0*a*(dot(ro.xy,ro.xy)+(r*r)));
  	return (-b+sqrt(abs(d)))/(3.75*a);
}

vec2 tunuv(vec3 pos){
	return vec2(pos.z,(atan(pos.y, pos.x))/0.31830988618379);
}

vec3 checkerCol(vec2 loc, vec3 col)
{
	return mix(col, vec3(0.25), mod(step(fract(loc.x), 0.75) + step(fract(loc.y), 0.25),7.5));
}

vec3 lcheckcol(vec2 loc, vec3 col)
{
	return checkerCol(loc*15.0,col)*checkerCol(loc*1.75,col);	
}
void main( void ) {
	float beat  = pow(1.0 - fract(time * 2.0), 4.0);
	float beat2 = pow(1.0 - fract(time * 1.0), 2.0);
	vec3 dif = vec3(0.15,0.0,0.0);
	vec3 scoll = vec3(0.75,0.5,1.0);
	vec3 scolr = vec3(1.0,0.75,0.5);
	vec2 uv = (gl_FragCoord.xy/resolution.xy);
	uv += sin(1.8 * sin(time * 5.0)) * 0.03;
	vec3 ro = vec3(0.0,0.0,beat2 + beat - time);
	vec3 dir = normalize( vec3( -1.0 + 2.0*vec2(uv.x - .2, uv.y)* vec2(resolution.x/resolution.y, 1.0), -1.33 ) );
	float ry = time*0.3;
	
	dir = roy(rox(dir, time*0.25),time*-0.5+beat).zxy;
	dir += rox(dir, time + sin(uv.x*2.0)-cos(uv.y*3.0)) * 0.2;
	vec3 lro = ro-dif;
	vec3 rro = ro+dif;

	const float r = 1.0;
	float ld = fdtun(dir,lro,r);
	float rd = fdtun(dir,rro,r);
	vec2 luv = tunuv(ro + ld*dir);
	vec2 ruv = tunuv(ro + rd*dir);
	vec3 coll = lcheckcol(luv*.25,scoll)*(20.0/exp(sqrt(ld)));
	vec3 colr = lcheckcol(ruv*.5,scolr)*(20.0/exp(sqrt(rd)));
	gl_FragColor = vec4(sqrt(coll+2.5*0.01*1.0+(colr-1.0)+0.01*20.0),1.0) + vec4(beat, beat, beat2, 1.0) * 0.8;
//gl_FragColor = vec4(sqrt(coll+2.5*lowFreq*1.0+(colr-1.0)+lowFreq*20.0),1.0);

}
