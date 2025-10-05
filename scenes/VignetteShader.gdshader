shader_type canvas_item;

uniform float outer_radius : hint_range(0.0, 2.0) = 1.4;
uniform float intensity : hint_range(0.0, 1.0) = 1;
uniform float softness : hint_range(0.0, 1.0) = 1;

void fragment() {
    vec2 uv = UV * 2.0 - 1.0;
    float dist = length(uv);
    float vignette = smoothstep(outer_radius - softness, outer_radius, dist);
    COLOR = vec4(vec3(0.0), vignette * intensity);
}
