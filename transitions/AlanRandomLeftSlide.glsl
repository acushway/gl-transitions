// Author: Alan
// License: MIT

#define DIVISION 20.
#define PI 3.14159

// basic function
float hash(in float v) { return fract(sin(v)*43237.5324); }
float hash(in vec2 v) { return fract(sin(dot(v, vec2(12.9898, 78.233)))*43237.5324); }
float noise(in float v) { float f=fract(v), i=floor(v), u=f*f*(3.-2.*f); return mix(hash(i), hash(i+1.), u); }

// transition
// ratio - value to select video, 0~1
// st - uv coordination of the pixel.
vec4 transition(float ratio, in vec2 st, float iTime) {
    float n = DIVISION;
	float thr = noise(1.+8.*floor(st.y*n)/n + iTime);
    vec2 uv = st + vec2(smoothstep(-thr, thr, ratio*2.-1.), 0.);
    vec2 uv1 = uv;
    vec2 uv2 = uv-vec2(1., 0.);
    return mix(getFromColor(uv1), getToColor(uv2), ratio);
}

vec4 transition (vec2 uv) {
  float iTime = progress * PI / 2.;
  float ratio = sin(iTime);
  vec4 video = transition(ratio, uv, ratio);

  return video;
}
