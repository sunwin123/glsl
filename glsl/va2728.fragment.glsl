/*
   Raymarcheing with basic ambient occlusion
   By Caiwan / IR
*/

//building off paulo falcao's raymarch framework -alice

#ifdef GL_ES
precision highp float;
#endif

uniform vec2 resolution;
uniform float time;
uniform vec2 mouse;
//Simple raymarching sandbox with camera

//Raymarching Distance Fields
//About http://www.iquilezles.org/www/articles/raymarchingdf/raymarchingdf.htm
//Also known as Sphere Tracing
//Original seen here: http://twitter.com/#!/paulofalcao/statuses/134807547860353024

//Declare functions
vec2 ObjUnion(in vec2 d1,in vec2 d2);
vec2 obj_floor(in vec3 p);
vec3 color_checkers(in vec3 p);
vec2 obj_roundBox(in vec3 p);
vec2 obj_unsignedBox(in vec3 p);
vec3 color_white(in vec3 p);
vec2 distanceField(in vec3 p);
vec2 obj_manyBoxes(in vec3 p);
vec4 applyFog (in vec4 currColor, in vec3 ray, in vec3 sunDir);

#define SHADING_MODE 3
#define CAMERA_MODE 0
#define AMBIENT_OCCLUSION

//Raymarching parameters
const float MAX_DEPTH=60.0; //Max depth
const int MAX_STEPS = 64; // max number of steps
const float MIN_DIST = 0.001;

// AO parameters
const int   AO_STEP = 16;
const int   AO_RAY_MAX_STEP = 8;
const float AO_RAY_MAX_DIST = 2.;
const float AO_RADIUS = .1;

//Util Start
vec2 ObjUnion(in vec2 d1,in vec2 d2){
	if (d1.x<d2.x)
	return d1;
	else
	return d2;
}

vec2 distanceField(in vec3 p){
	return ObjUnion(obj_floor(p),obj_manyBoxes(p));
}

// http://www.ozone3d.net/blogs/lab/20110427/glsl-random-generator/
float rand(vec2 n)
{
	return 0.5 + 30.5*fract(sin(dot(n.xy, vec2(12.9898, 78.233)))* 43758.5453);
}

float rand2(vec2 p) {
	return fract(sin(dot(p.xy,vec2(1.9898,78.233)))*43758.5453);
}

vec3 noise(vec2 f) {
	return vec3(rand2(f-1.), rand2(f), rand2(f+1.));
}

//Util End

//Scene Start
// ============OBJECTS============= //
//FLOOR (color is determined by y-component, ie 0.0)
vec2 obj_floor(in vec3 p){
	return vec2(p.y,0);
}

//IQ's ROUNDOX (try other objects http://www.iquilezles.org/www/articles/distfunctions/distfunctions.htm)
//(color is determined by y-component, ie 1.0)
vec2 obj_roundBox(in vec3 p){
	return vec2(length(max(abs(p)-vec3(1,1,1),0.0))-0.25,1);
}

// UNSIGNED BOX
vec2 obj_unsignedBox(in vec3 p){
	return vec2(length(max(abs(p)-vec3(1,1,1),0.0)),1);
}

// INFINITE BOXES
vec2 obj_manyBoxes(in vec3 p){
	vec3 c = vec3(5.0,5.0,5.0);
	vec3 q = mod(p,c)-0.5*c;
	return obj_unsignedBox(q);
}

// ============COLORS============= //
// Checkerboard Color
vec3 color_checkers(in vec3 p){
	if (fract(p.x*.5)>.5)
	if (fract(p.z*.5)>.5)
	return vec3(0.5,0.5,0.5);
	else
	return vec3(.75,.75,.75);
	else
	if (fract(p.z*.5)>.5)
	return vec3(.75,.75,.75);
	else
	return vec3(0.5,0.5,0.5);
}

// White color
vec3 color_white(in vec3 p){
	return vec3(1.0,1.0,1.0);
}

//Scene End

vec3 getNormal(float dist, vec3 p){
	const vec3 e=vec3(0.1,0,0);
	return normalize( vec3(dist-distanceField(p-e.xyy).x, dist-distanceField(p-e.yxy).x, dist-distanceField(p-e.yyx).x));
}

//raymarching 
vec3 intersect(vec3 E, vec3 rayDir, out vec3 p, out int steps, out float totalDist){
	vec3 dist = vec3(0.0,0.0,1.0);
	totalDist=0.0;

	steps = 0;
	for(int i=0;i<MAX_STEPS;i++){
		steps++;
		totalDist+=dist.x;
		p=E+rayDir*totalDist; // p = eye + total_t*rayDir
		dist.xy = distanceField(p);
		if (abs(dist.x)<MIN_DIST||totalDist>MAX_DEPTH) break; // break when p gets sufficiently close to object or exceeds max dist
	}
	
	// ambient occlusion
#ifdef AMBIENT_OCCLUSION
	vec3 normal = getNormal(dist.x, p);
	vec3 rvec = vec3(.5, .7, .2);
	
	vec3 tangent = normalize(rvec - normal * dot(rvec, normal));
	vec3 bitangent = cross(normal, tangent);
	mat3 tbn = mat3(tangent, bitangent, normal);
	
	float occlusion = 0.;
	
	for(int i = 0; i < AO_STEP; ++i) 
	{
		vec3 vray = tbn * normalize(noise(p.xy+vec2(i*i))), sample = vec3(0,0,0);
		float ao_totalDist = 0.0;
		float ao_inters = 0.0;
		
		int ao_step = 0;
		
		for (int j = 0; j<AO_RAY_MAX_STEP; ++j)
		{
			ao_totalDist += ao_inters;
			sample = p + vray * ao_totalDist;
			//sample = p + vray;
			ao_inters = distanceField(sample).x;
			if (abs(ao_inters) < MIN_DIST || ao_totalDist > AO_RAY_MAX_DIST) break;
			
			ao_step ++;
		}
		if ((ao_step < AO_RAY_MAX_STEP) && (length(sample-p) < AO_RADIUS)) occlusion += 1.;
		//if ((abs(sample.z - p.z) < AO_RADIUS) && (p.z < sample.z)) occlusion += 1.;
	}
	
	occlusion = 1. - occlusion / float(AO_STEP);
	
	dist.z = occlusion;
	
#endif
	
	return dist;
}

void main(void){
	//Camera animation
	vec3 U=vec3(0,1,0);//Camera Up Vector
	vec3 viewDir=vec3(0,0,0); //Change camere view vector here
	vec3 E;
	if (CAMERA_MODE == 0)
	E=vec3(-sin(time/10.0)*10.0,5,cos(time/10.0)*10.0); //spinning scene
	else if(CAMERA_MODE == 1){
		float spin = mouse.x * 8.0; //time * 0.1 + mouse.x * 8.0;
		E=vec3(-sin(spin)*4.0, 8.0 * mouse.y, cos(spin)*4.0);//Change camera path position here
	}
	else if(CAMERA_MODE == 2)
	E=vec3(-sin(time/10000.0)*10.0,5,cos(time/10000.0)*10.0);
	
	//Camera setup
	vec3 C=normalize(viewDir-E);
	vec3 A=cross(C, U);
	vec3 B=cross(A, C);
	vec3 M=(E+C);

	vec2 vPos=2.0*gl_FragCoord.xy/resolution.xy - 1.0; // = (2*Sx-1) where Sx = x in screen space (between 0 and 1)
	vec3 P=M + vPos.x*A*resolution.x/resolution.y + vPos.y*B; //normalize resolution in either x or y direction (ie resolution.x/resolution.y)
	vec3 rayDir=normalize(P-E); //normalized direction vector from Eye to point on screen
	
	vec3 c, n, p = vec3(0.,0.,0.);
	int steps = 0;
	float totalDist;
	vec3 dist = intersect(E, rayDir, p, steps, totalDist);

	vec4 finalColor = vec4(1,1,1,1);
	if (totalDist<MAX_DEPTH){
		// check which color to use in the y-component
		if (dist.y==0.0)
		c=color_checkers(p);
		else if(dist.y==1.0)
		c=color_white(p);

		if(SHADING_MODE==1){
			// compute normal at this point on the surface using a gradient vector
			vec3 n = getNormal(dist.x, p);
			//simple phong LightPosition=CameraPosition	   
			float b=dot(n,normalize(E-p));
			finalColor=vec4((b*c+pow(b,8.0))*(1.0-totalDist*.01),1.0);
		}
		// AO only
		else if (SHADING_MODE == 3){
			finalColor = vec4(c * dist.z, 1.);
		}
		else{
			//Shading based on raymarched distance
			float v = 1.0-float(steps)/float(MAX_STEPS);
			float R=v*c.r, G=v*c.g, B=v*c.b;
			finalColor=vec4(R,G,B,1.0);
		}
		
		//apply fog
		vec3 r = p-E;
		vec3 sunDir = vec3(1,0,0);
		finalColor = applyFog(finalColor, r, sunDir);
		gl_FragColor = finalColor;
	}
	//apply fog
	//vec3 r = p-E;
	//vec3 sunDir = vec3(1,0,0);
	//finalColor = applyFog(finalColor, r, sunDir);
	gl_FragColor = finalColor;
}

// Fog
vec4 applyFog (in vec4 currColor, in vec3 ray, in vec3 sunDir){
	float rayLength = length(ray);
	vec3 nRay = ray/rayLength;
	
	float fogAmount = 1.0-exp(-rayLength * 0.008);
	float sunAmount = pow( max( dot (nRay, sunDir), 0.0), 8.0);
	
	vec4 fogColor = mix(vec4(0.5,0.6,0.7,1.0), vec4(1.0,0.9,0.7,1.0), sunAmount);
	return mix(currColor, fogColor, fogAmount);
}