precision mediump float;
uniform float time;
uniform vec2 resolution;
//varying vec2 surfacePosition;
uniform vec2 mouse;

mat2 rmat(float r)
{
    float c = cos(r);
    float s = sin(r);
    return mat2(c, s, -s, c);
}


float map(in vec3 p) 
{
	vec3	o = p;
	p 		*= .25;

	float res 	= 1.;
	vec3 c 		= p;
	for (int i = 0; i < 4; i++) 
	{	
		p 	= fract(abs(p-.125)/dot(p,p));
		p	+= p.yzx-.5;
		res 	+= clamp(1./abs(16.*dot(p,c)), .001, res)/1.5;
	}

	return max(.00001, res);
}


vec3 hsv(float h,float s,float v)
{
	return mix(vec3(1.),clamp((abs(fract(h+vec3(3.,2.,1.)/3.)*6.-3.)-1.),0.,1.),s)*v;
}


void main()
{
	vec2 uv = gl_FragCoord.xy/resolution;
	uv	= (uv - .5) * resolution/min(resolution.x, resolution.y);
	
	uv.x 		+= .25;
	vec3 origin 	= vec3(1., 4., 2.);
	origin.xz 	*= rmat(time * -6.0025 + time * 6.28);
	
	vec3 up 		= vec3(0., 1., 0.);
	float fov 	= .125;
	vec3 u 		= normalize(cross(origin, up));
	vec3 v 		= normalize(cross(u,  origin));
	vec3 direction	= normalize(uv.x * u + uv.y * v - fov * origin);

	vec3 color = vec3(0);
	vec3 position 	= origin;
	float mass 	= 0.;
	float density 	= 1.;
	
	float depth 	= 4.0;
	for( int i = 0; i < 32; i++ )
	{
		depth 		+= log(max(.1, depth/float(i+1)));		
		position	= origin	 + direction * depth;
		float mass 	= map(position);
		density		+= log(max(0.6, mass*.5))/8.;
		color		+= hsv(depth*.015-mass/5., 1., 1.)*mass/65.;
	}    


	color			+= hsv(density/32., 1., 1.)*.3-.1;
	
	vec4 result 		= vec4(0.);
	result.xyz		= color * density;

	result.w			= 1.;
	
	gl_FragColor 		= result;
}
//original code from https://www.shadertoy.com/view/MtX3Ws
//simplified edit: Robert 25.11.2015