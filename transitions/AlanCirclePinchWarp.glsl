// Author: Alan
// License: MIT

vec4 transition(float ratio, in vec2 st) {
    vec2 p = st*2.-1.;
    float l = length(p) / sqrt(2.);
    float ll = smoothstep(l-0.04, l+0.04, ratio);
    if (ratio == 0.) {
      ll = 0.;
    } else if (ratio == 1.) {
      ll = 1.;
    }
    
    float w = 0.3;
    vec2 p1 = p*(1.+smoothstep(0., l+w, ratio));
    vec2 p2 = p*smoothstep(l-w, 1./*smoothstep(l+w, 1., ratio)*/, ratio);
    
    vec2 uv1 = p1*0.5+0.5;
    vec2 uv2 = p2*0.5+0.5;
    // return vec4(l, 0., 0., 1.);
    // return vec4(step(0.99, l), 0., 0., 1.);
    return mix(getFromColor(uv1), getToColor(uv2), ll);
}

vec4 transition (vec2 uv) {
  float ratio = smoothstep(0., 1., progress);
  vec4 video = transition(ratio, uv);
  return vec4(video.rgb,1.0);
}
