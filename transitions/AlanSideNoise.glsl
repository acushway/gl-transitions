// Author: Alan
// License: MIT

float random (vec2 st) {
    return fract(sin(dot(st.xy,vec2(12.9898,78.233)))*43758.5453123);
}

vec4 transition (vec2 uv) {
    float fade = smoothstep(0., 1., progress);
    fade = smoothstep(0., 1., fade);
    fade = smoothstep(0., 1., fade);
    
    vec2 texCoords = uv;
    float offset = random(uv) * .7;
    float f = clamp(sin(fade * 3.14159), .0, 1.);
    texCoords.x += offset * f;
    float fader = step(texCoords.x, fade);
    vec4 video_a = getFromColor(texCoords);
    vec4 video_b = getToColor(texCoords);
    return mix(video_a, video_b, fader);
}
