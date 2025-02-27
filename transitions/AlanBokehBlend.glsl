// Author: Alan
// License: MIT

#define S(a,b,c) smoothstep(a,b,c)

// Borrowed from BigWIngs (random 1 -> 4)
vec4 N14(float t) {
	return fract(sin(t*vec4(123., 104., 145., 24.))*vec4(657., 345., 879., 154.));
}

// Compute a randomized Bokeh spot inside a grid cell
float bokehSpot(vec2 uv, vec2 id, float decimation, float time)
{
    float accum = 0.0;

    for (float x = -1.0; x <= 1.0; x += 1.0)
    {
        for (float y = -1.0; y <= 1.0; y += 1.0)
        {
            vec2 offset = vec2(x, y);
            vec2 cellId = id + offset;
            vec4 rnd = N14(mod(cellId.x, 300.0) * 25.3 + mod(cellId.y, 300.0) * 6.67);

            vec2 cellUV = uv - offset + rnd.yz * 0.5;

            float dst = length(cellUV);

            float radSeed = sin(time * 0.02 + rnd.x * 40.0);
            float rad =  (abs(radSeed) - decimation) / (1.0 - decimation);

            float intensity = S(rad, rad - 0.15, dst);

            accum += intensity;
        }
    }

    return accum;
}

// Computes a random layer of bokeh spots
float bokehLayer(vec2 uv, float decimation, float time)
{
    vec2 id = floor(uv);
    vec2 cellUV = (uv - id) - vec2(0.5, 0.5) ;

    float intensity = bokehSpot(cellUV, id, decimation, time);

    return intensity;
}


// Computes the bokeh background
vec3 bokeh(vec2 uv, float time)
{
    //accumulates several layers of bokeh
    float intensity = bokehLayer(uv * 0.2 + vec2(time * 0.3, 0.0), 0.9, time) * 0.2;
    //intensity += bokehLayer(uv * 0.8 + vec2(200.0 + iTime * 0.3, 134.0), 0.9) * 0.3;
    intensity += bokehLayer(uv * 0.5 + vec2(0.0 + time * 0.3, 334.0), 0.95, time) * 0.15;
    intensity += bokehLayer(uv * 0.1 + vec2(time * 0.3, 99.0), 0.95, time) * 0.05;

    float cDist = max(0.0, 1.0 - length(uv) * 0.05);

    intensity = cDist + intensity;

    // Vary color with intensity
    // First color is the blue
    // Second color is the green
    vec3 chroma = mix(vec3(236.0/255.0, 133.0/255.0, 209.0/255.0), vec3(100.0/255.0, 180.0/255.0, 255.0/255.0), uv.y * 0.1 + 0.4 + intensity * 0.35444777);

    return chroma * intensity;
}

vec4 transition (vec2 uv) {
    vec2 scaledUV = uv * 10.;

    vec3 bg = bokeh(scaledUV, progress * 15.);

    bg.rgb -= scaledUV.y * 0.01;

    vec3 col = bg;

    // Gamma correction to make the image warmer
    float gamma = 0.8;
    col.rgb = pow(col.rgb, vec3(gamma));
    
    if (progress < 0.5) {
      return mix(getFromColor(uv), vec4(col, 1.0), progress * 2.);
    }
    
    return mix(vec4(col, 1.0), getToColor(uv), (progress - 0.5) * 2.);
}
