#ifdef GL_ES
precision mediump float;
#endif

#extension GL_OES_standard_derivatives : enable

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

float rand(vec2 n) { 
	return fract(sin(dot(n, vec2(13, 5))) * 43758.5453);
}

float noise(vec2 n) {
	const vec2 d = vec2(0.0, 1.0);
	vec2 b = floor(n), f = smoothstep(vec2(0.0), vec2(1.0), fract(n));
	return mix(mix(rand(b), rand(b + d.yx), f.x), mix(rand(b + d.xy), rand(b + d.yy), f.x), f.y);
}

float fbm(vec2 n) {
	float total = 0.0, amplitude = 1.0;
	for (int i = 0; i < 5; i++) {
		total += noise(n) * amplitude;
		n += n;
		amplitude *= 0.5;
	}
	return total;
}

vec3 tex(vec2 pos) {
	const vec3 c1 = vec3(.1,0,0);
	const vec3 c2 = vec3(.7,0,0);
	const vec3 c3 = vec3(.2,0,0);
	const vec3 c4 = vec3(1,.9,0);
	const vec3 c5 = vec3(.1);
	const vec3 c6 = vec3(.9);
	vec2 p = pos;
	float q = fract(fbm(p - (time) * -0.1));
	q=min(q, fbm(p*20.));
	vec2 r = vec2(fbm(p + q - p.x - p.y), fbm(p + q + time));
	vec3 c = mix(c1, c2, fbm(p + r)) + mix(c3, c4, r.x) - mix(c5, c6, r.y);
	return c;
}




void main(void) {

    vec2 p = (gl_FragCoord.xy / resolution - vec2(.5)) * vec2(resolution.x/resolution.y, 1.);


    float r = length(p);
    float a = atan(p.y, p.x);

    vec2 uv = vec2(sin(a), cos(a))/pow(r, 1.+.5*sin(time));
    
    vec3 col = tex(uv);
    gl_FragColor = vec4(col*length(p),1);

}