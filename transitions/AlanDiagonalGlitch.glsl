// Author: Alan
// License: MIT

#define GRID_SIZE 20.

const float PI = acos(-1.);

float screenIn(in vec2 uv) { return step(abs(uv.x-0.5), 0.5) * step(abs(uv.y-0.5), 0.5); }
mat2 rotate(in float r) { float c=cos(r),s=sin(r); return mat2(c,-s,s,c); }
float hash(in float v) { return fract(sin(v)*43237.5324); }
float hash(in vec2 v) { return fract(sin(dot(v, vec2(12.9898, 78.233)))*43237.5324); }

// transition
// ratio - value to select video, 0~1
// st - uv coordination of the pixel.
vec4 transition(float ratio, in vec2 st) {
    vec2 uv = st;
    uv *= rotate(PI/6.);
    
    uv.y *= GRID_SIZE;
    vec2 id = vec2(0.);
    id.y = floor(uv.y);
    uv.x *= GRID_SIZE*hash(id.y);
    id.x = id.y + floor(uv.x);
    
    float angle = sign(hash(id.x)*2.-1.);
    float offset = hash(id.x + id.y)+1.414;
    
    vec2 uv1 = st;
    vec2 uv2 = st + vec2(angle * offset * ratio, 0.)*rotate(-PI/6.);
    
    return screenIn(uv2)<1. ? getToColor(uv1) : getFromColor(uv2);
}

vec4 transition (vec2 uv) {
  float iTime = progress;
  float ratio = smoothstep(0., 1., progress);
  ratio = smoothstep(0., 1., ratio);
  ratio = smoothstep(0., 1., ratio);
  return transition(ratio, uv);
}
