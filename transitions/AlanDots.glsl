// Author: Alan
// License: MIT

vec4 transition (vec2 uv) {
  float iTime = progress * 3.;
  
	vec2 p = uv*2.0 - 1.0;
    float as = 1.;
    
    vec3 col1 = getFromColor(uv).rgb;
    vec3 col2 = getToColor(uv).rgb;

    float g = sin(iTime + 4.4)*2.2;
    
    float a = clamp(cos(p.x*200.0)-cos(p.y*200.0*as)+g+1.0,0.0,1.0);
    a = pow(a,10.0);
    vec3 col = mix(col1,col2,a);
    // Output to screen
    return vec4(col,1.0);
    
  return mix(
    getFromColor(uv),
    getToColor(uv),
    progress
  );
}
