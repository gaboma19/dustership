shader_type canvas_item;

uniform sampler2D dissolve_texture : source_color;
uniform float dissolve_value : hint_range(0,1);
uniform float ratio = 1;

void fragment() {
	vec2 UV_TILE = vec2(UV.x / ratio, UV.y);
    vec4 main_texture = texture(TEXTURE, UV_TILE);
    vec4 noise_texture = texture(dissolve_texture, UV_TILE);
    main_texture.a *= floor(dissolve_value + min(1, noise_texture.x));
    COLOR = main_texture;
}
