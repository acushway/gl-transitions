// Author: Alan
// License: MIT
// https://www.shadertoy.com/view/3tjXWd

#define TIME_MULT   .25
#define IDLE_TIME   .05

#define rnd(p) fract(sin(dot(p, vec2(12.9898,78.233))) * 43758.5453123)

vec4 transition (vec2 uv) {
  vec2 U=uv, B;
  float p = 1. / 60.;
  U *= 6.;
	
	float iTime = progress * 3.8;
    
    float t = fract(iTime * TIME_MULT),
         mt = ceil(iTime * TIME_MULT),
        cellStartTime = rnd(ceil(U) * mt) * .5 + IDLE_TIME,
          w = .25 + .75* smoothstep(0., .175, t-cellStartTime-.225);

    B =  t < cellStartTime 
             ? vec2(0) 
             : smoothstep(p,0.,abs(fract(U)-.5) - w/2. );
    return mix(getFromColor(uv),getToColor(uv), B.x*B.y);
}
