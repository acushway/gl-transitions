// Author: Alan
// License: MIT

vec4 transition (vec2 uv) {
  // Tweakable parameters
  // I'm not sure they are well named for what they do.
  // I'd like it if period was calculated from the others such that the effect always loops cleanly.
  float freq = 8.0;
  float period = 8.0;
  float speed = 2.0;
  float fade = 4.0;
  float displacement = 0.2;

  vec2 U = (uv - vec2(0.5)) * 2.;
  vec2 T = uv;
  float D = length(U);
  
  float time = progress * 2.5;
  
  if (progress == 0.) {
    return getFromColor(uv);
  } else if (progress == 1.) {
    return getToColor(uv);
  }
  
  float frame_time = mod(time * speed, period);
  float pixel_time = max(0.0, frame_time - D);

  float wave_height = (cos(pixel_time * freq) + 1.0) / 2.0;
  float wave_scale = (1.0 - min(1.0, pixel_time / fade));
  float frac = wave_height * wave_scale;

  vec2 tc = T + ((U / D) * -((sin(pixel_time * freq) / fade) * wave_scale) * displacement);
  
  return mix(
    getFromColor(tc),
    getToColor(tc),
    1. - frac
  );
}
