// Thematica le 19 juin 2013 :Trois Balles
// credit: http://www.iquilezles.org/www/articles/distfunctions/distfunctions.htm

#ifdef GL_ES
precision mediump float;
#endif
uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const float deltaT=1.5;
const float rPiste=1.8;
vec3 colcontact=vec3(0.,1.0,0.);
vec3 centreBalle=vec3(0.,0.,0.);
float rBalle=0.2;
vec3 centrePiste=vec3(0.0,0.0,1.0);


float sdPlane( vec3 p )
{
	return p.y+0.2;
}

float sdSphere( vec3 p, float s ,vec3 centre)
{
    return length(p-centre)-s;
}

float sdCyl(vec3 p, float h,float r){
vec3 pa=abs(p);
float ra=length(pa.xz);
float k=(r<ra)? length(vec2(ra-r,pa.y-h)) : pa.y-h-0.001;
 return (pa.y<h)?(ra-r) : k;


}

float udRoundBox( vec3 p, vec3 b, float r )
{
  return length(max(abs(p)-b,0.05))-r;
}

float udBox( vec3 p, vec3 b )
{
  return length(max(abs(p)-b,0.0));
}




//----------------------------------------------------------------------

float opS( float d1, float d2 ){  return max(-d2,d1);}
vec4 opS( vec4 d1, vec4 d2 ){ return vec4(max(-d2.x,d1.x),d2.yzw);}

float opU( float d1, float d2 ){	return (d1<d2) ? d1 : d2;}
vec2 opU( vec2 d1, vec2 d2 ){return (d1.x<d2.x) ? d1 : d2;}

vec4 opU( vec4 d1, vec4 d2 ){return (d1.x<d2.x) ? d1 : d2;}
vec3 opRep( vec3 p, vec3 c ){ return mod(p,c)-0.5*c;}


vec3 rotZ( vec3 p, float te )
{
    float  c = cos(te),  s = sin(te);
    mat3  mz = mat3(c,-s,0.0,s,c,0.0,0.0,0.0,1.0);//rotation autour de Z
    return mz*p;
}
vec3 rotY( vec3 p, float te )
{
    float  c = cos(te),  s = sin(te);
    mat3  my = mat3(c,0.0,-s , 0.0,1.0,0.0, s,0.0,c);//rotation autour de Y
    return my*p;
}
vec3 rotX( vec3 p, float te )
{
    float  c = cos(te), s = sin(te);
    mat3  my = mat3( 1.0,0.0,0.0, 0.0,c, -s, 0.0,s,c);//rotation autour de X
    return my*p;
}

vec3 BallCenter(float ind){	
	float timeo=time*0.7;
	float rPist=rPiste*1.4;
	float alpha0=clamp(sin(timeo*3.0+ind*deltaT),-3.0,3.0)+deltaT*ind;
	float rai=clamp(rPist*sin(timeo),-rPist*0.3,rPist*0.4)+rPist*0.6;
	vec3 vr=rotY(vec3(rai,0.,0.),timeo+alpha0);
	return centrePiste+vr;
}	
                                                                                   

//----------------------------------------------------------------------

vec4 pointToObjects( in vec3 pos ){
	vec4 r4=vec4(sdCyl(pos-centrePiste-vec3(0.,-2.*rBalle,0.),rBalle*1.1,rPiste+rBalle+1.2),1.,0.,0.);	
	 vec4 r1= vec4(sdSphere( pos ,rBalle,BallCenter(0.) ),1.0,1.0,0.);
	 r4=opU(r4,r1);
	 r1= vec4(sdSphere( pos ,rBalle,BallCenter(1.) ),1.0,1.0,0.);
	 r4=opU(r4,r1);
	  r1= vec4(sdSphere( pos ,rBalle,BallCenter(2.) ),1.0,1.0,0.);
	 r4=opU(r4,r1);
    	vec4 res = opU( vec4( sdPlane(pos-vec3(0.,-rBalle,0.)), 1.0,0.,1.0 ), r4);	
   	return res;
}



vec4 castRay( in vec3 ro, in vec3 rd )
{
    float precis = 0.001;
    float h=1.0/60.0;
    float t = 0.0;
   vec3 m = vec3(0.,0.,0.);
    for( int i=0; i<60; i++ )
    {
        if( abs(h)<precis||t>20.0 ) break;
        t += h;
        vec4 res = pointToObjects( ro+rd*t );
        h = res.x;
        m = res.yzw;
    }

    if( t>20.0 ) m=vec3(0.,0.,0.);
    return vec4( t, m );
}


float softshadow( in vec3 ro, in vec3 rd, in float mint, in float maxt, in float k )
{
	float res = 1.0;
    float dt = 0.02;
    float t = mint;
    for( int i=0; i<20; i++ )
    {
	if( t<maxt )
		{
        float h = pointToObjects( ro + rd*t ).x;
        res = min( res, k*h/t );
	t += 0.02;			
		}
    }
    return clamp( res, 0.0, 1.0 );

}
//--------------------------------------------------------------------------
vec3 calcNormal( in vec3 pos )
{
	vec3 eps = vec3( 0.001, 0.0, 0.0 );
	vec3 nor = vec3(
	pointToObjects(pos+eps.xyy).x - pointToObjects(pos-eps.xyy).x,
	pointToObjects(pos+eps.yxy).x - pointToObjects(pos-eps.yxy).x,
	pointToObjects(pos+eps.yyx).x - pointToObjects(pos-eps.yyx).x );
	return normalize(nor);
}
//---------------------------------------------------------------------------
float calcAO( in vec3 pos, in vec3 nor )// comme une  ombre de la lumiere ambiante
{
    float totao = 0.0;
    float sca = 1.0;// le scale est 1
    for( int aoi=0; aoi<2; aoi++ )
    {
        float hr = .05 + 0.1*float(aoi);
        vec3 aopos =  nor * hr + pos;
        float dd = pointToObjects( aopos ).x;
        totao += -(dd-hr)*sca;
        sca *= 0.75;// le scale est diminué
    }
    return clamp( 1.0 - 10.0*totao, 0.0, 1.0 );
}




vec3 render( in vec3 ro, in vec3 rd )
{ 
    vec3 col = vec3(0.,0.,0.);
    vec4 res = castRay(ro,rd);
    float t = res.x;           
   vec3 m = res.yzw; 

 
        vec3 pos = ro + t*rd;
        vec3 nor = calcNormal( pos );

		col = m;		
		float ao = calcAO( pos, nor );

		vec3 lig = normalize( vec3(1.0, 0.5, -1.0) );         
		float amb = clamp( 0.5+0.5*nor.y, 0.0, 1.0 );   
		float dif = clamp( 1.5*dot( nor, lig ), 0.0, 1.0 );                              
		float bac = clamp( dot( nor, normalize(vec3(-lig.x,0.0,-lig.z))), 0.0, 1.0 )*clamp( 1.0-pos.y,0.0,1.0);

		float sh = 1.0;
		if( dif>0.02 ) { sh = softshadow( pos, lig, 0.12, 10.0, 7.0 ); dif *= sh; }   //l'ombre pas si douce

		vec3 brdf = vec3(0.0);
		brdf += 0.20*amb*vec3(0.10,0.11,0.13)*ao;
        		brdf += 0.20*bac*vec3(0.15,0.15,0.15)*ao;
        		brdf += 1.20*dif*vec3(1.00,0.90,0.70);

		float pp = clamp( dot( reflect(rd,nor), lig ), 0.0, 1.0 );
		float spe = sh*pow(pp,32.0);
		float fre = ao*pow( clamp(1.0+dot(nor,rd),0.0,1.0), 2.0 );

		col = col*brdf + vec3(1.0)*col*spe + 0.2*fre*(0.1+0.9*col);
		col = col*brdf  ;		
	col *= exp( -0.01*t*t );
	return sqrt(vec3( clamp(col,0.0,1.0) ));
}

void main( void )
{	
	vec2 p = 2.0*gl_FragCoord.xy/resolution.xy-1.0;	
	p.x*=resolution.x/resolution.y;
	float angleCamX=-0.5;
	float angleCamY=0.3;
	vec3 ro =rotY( rotX(vec3( 0.0, 0.0 , -4.0),angleCamX),angleCamY);
	vec3 rd=normalize(rotY(rotX(vec3(p.x,p.y,1.5),angleCamX),angleCamY));		
	vec3 col = render( ro, rd);	
	gl_FragColor=vec4( col.x, col.y*0.8,2.0*col.z,1.0 );

}
