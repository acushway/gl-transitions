// Author: Alan
// License: MIT

float hash(vec2 co) {
  return fract(sin(dot(co, vec2(12.9898,58.233))) * 13758.5453);
}

float tanh_approx(float x) {
//  return tanh(x);
  float x2 = x*x;
  return clamp(x*(27.0 + x2)/(27.0+9.0*x2), -1.0, 1.0);
}

// IQ's hex
float hex(vec2 p, float r) {
  p.xy = p.yx;
  const vec3 k = vec3(-sqrt(3.0/4.0),1.0/2.0,1.0/sqrt(3.0));
  p = abs(p);
  p -= 2.0*min(dot(k.xy,p),0.0)*k.xy;
  p -= vec2(clamp(p.x, -k.z*r, k.z*r), r);
  return length(p)*sign(p.y);
}

// See Art of Code: Hexagonal Tiling Explained!
// https://www.youtube.com/watch?v=VmrIDyYiJBA
vec2 hextile(inout vec2 p) {
  const vec2 sz       = vec2(1.0, sqrt(3.0));
  const vec2 hsz      = 0.5*sz;

  vec2 p1 = mod(p, sz)-hsz;
  vec2 p2 = mod(p - hsz, sz)-hsz;
  vec2 p3 = dot(p1, p1) < dot(p2, p2) ? p1 : p2;
  vec2 n = ((p3 - p + hsz)/sz);
  p = p3;

  n -= vec2(0.5);
  
  return vec2(floor((n.x * 2.) * 0.5) / 2.,  floor((n.y * 2.) + 0.5) / 2.);
  // Rounding to make hextile 0,0 well behaved
  // return round(n*2.0) / 2.0;
}

vec3 hexTransition(vec2 p, float aa, vec3 from, vec3 to, float m) {
  m = clamp(m, 0.0, 1.0);
  const float hz = 0.125;
  const float rz = 0.75;
  vec2 hp = p;
  hp /= hz;
//  hp *= ROT(0.5*(1.0-m));
  vec2 hn = hextile(hp)*hz*-vec2(-1.0, sqrt(3.0));
  float r = hash(hn+123.4);
  
  const float off = 3.0;
  float fi = smoothstep(0.0, 0.1, m);
  float fo = smoothstep(0.9, 1.0, m);

  float sz = 0.45*(0.5+0.5*tanh_approx(((rz*r+hn.x + hn.y-off+m*off*2.0))*2.0));
  float hd = (hex(hp, sz)-0.1*sz)*hz;
  
  float mm = smoothstep(-aa, aa, -hd);
  mm = mix(0.0, mm, fi);
  mm = mix(mm, 1.0, fo);
  
  vec3 col = mix(from, to, mm);
  return col;
}

vec4 transition (vec2 uv) {
  
  vec3 col = hexTransition(uv, 0.004, getFromColor(uv).rgb, getToColor(uv).rgb, progress);
  return vec4(col, 1.);
}
