// Author: Alan Cushway
// License: MIT

vec4 transition (vec2 uv) {
  float width = 0.08;
  
  float scaledProgress = -width + (progress * (1.0 + (width * 2.0)));
  
  float intensity = smoothstep(uv.x - width, uv.x, scaledProgress) - smoothstep(uv.x, uv.x + width, scaledProgress); 
  
  float mixVal = step(scaledProgress, uv.x);
  
  return vec4(intensity + ((1.0 - intensity) * mix(getToColor(uv), getFromColor(uv), mixVal)));
}
