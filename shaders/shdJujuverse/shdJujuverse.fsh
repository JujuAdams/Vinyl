//Anti-aliasing (natural number)
#define AA 2.
//Loop length in seconds.
#define L 32.
//Animation velocity (must be a factor of L)
#define V vec2(8,4)
//Procedural generation "seed".
#define S 0.
//Color count.
#define C 2.5

varying vec2 v_vTexcoord;
varying vec4 v_vColour;

uniform float u_fTime;

vec2 hash(vec2 p, float t)
{
    float a = mod(t,L/V.x);
    vec2 m = mod(p,L/V);
    return fract(cos(mat2(31,-41,59,-26)*m+a*56.+S)*535.);
}

vec3 shade(vec2 p)
{
    vec2 m = mod(p,L/V);
    float f = fract(m.x/5.-m.y/5.);
    vec3 c =         vec3( 64, 78,203) / 255.;
    c = (f<.2) ? c : vec3( 33,206,132) / 255.;
    c = (f<.4) ? c : vec3(196, 96,250) / 255.;
    c = (f<.6) ? c : vec3(249, 80,122) / 255.;
    c = (f<.8) ? c : vec3(254, 178,36) / 255.;
    return c;
}

vec2 value(vec2 p)
{
    float t = u_fTime/V.x;
    float a = fract(t);
 	vec2 f = floor(p);
    vec2 s = p-f;
    s *= s*(3.-2.*s);
    
    const vec2 o = vec2(0,1);
    return mix(mix(mix(hash(f+o.xx,t-a   ),hash(f+o.yx,t-a   ),s.x),
        	       mix(hash(f+o.xy,t-a   ),hash(f+o.yy,t-a   ),s.x),s.y),
               mix(mix(hash(f+o.xx,t-a+1.),hash(f+o.yx,t-a+1.),s.x),
        	       mix(hash(f+o.xy,t-a+1.),hash(f+o.yy,t-a+1.),s.x),s.y),a)-.5;
}

vec3 stripe(in vec2 p)
{
    #define tau 6.2831
    p = p+value(p)+value(p/.2)*.06+u_fTime/V;
    vec3 o = vec3(0);
    
    float d = 4.;
 	vec2 f = floor(p);
    
    for(float xx = -1.;xx<=1.;xx++)
    for(float yy = -1.;yy<=1.;yy++)
    {
        vec2 v = hash(f+vec2(xx,yy),0.)*1.4-p+f+vec2(xx,yy);
        float l = length(v);
        if (l<=d)
        {
            d = l;
            o = shade(f+vec2(xx,yy));
        }
    }
    return o;
}

void main()
{
    gl_FragColor = vec4(stripe(v_vTexcoord*C), 1.0);
    gl_FragColor.rgb = mix(gl_FragColor.rgb, v_vColour.rgb, v_vColour.a);
}