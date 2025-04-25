shader_type canvas_item;

uniform sampler2D noise_texture;
uniform float noise_scale : hint_range(0.1, 10.0) = 1.0;
uniform float distortion_scale_x : hint_range(0.0, 10.0) = 0.03;
uniform float distortion_scale_y : hint_range(0.0, 10.0) = 0.03;
uniform float rainbow_intensity : hint_range(0.0, 1.0) = 0.5;

void fragment() {
    vec4 base_texture = texture(TEXTURE, UV);

    vec2 noise_uv = UV * noise_scale;
    float noise_x = texture(noise_texture, noise_uv).r;
    float noise_y = texture(noise_texture, noise_uv).g;

    vec2 distorted_uv = UV + vec2(noise_x * distortion_scale_x, noise_y * distortion_scale_y);

    float rainbow_r = sin(distorted_uv.x * 15.0 + TIME * 0.1);
    float rainbow_g = sin(distorted_uv.y * 15.0 + TIME * 0.1 + 2.0);
    float rainbow_b = sin(distorted_uv.x * 10.0 + TIME * 0.1 + 4.0);

    vec3 rainbow_color = vec3(rainbow_r, rainbow_g, rainbow_b);
    rainbow_color = (rainbow_color + 1.0) * 0.5; // Normalize to [0.0, 1.0]

    vec3 final_color = mix(base_texture.rgb, rainbow_color, rainbow_intensity);

    COLOR = vec4(final_color, COLOR.a);
}
