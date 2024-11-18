/**
* Shadow 2D.
* License: CC0
* https://creativecommons.org/publicdomain/zero/1.0/
*/
shader_type canvas_item;
render_mode blend_mix;

uniform vec2 deform = vec2(2.0, 2.0);
uniform vec2 offset = vec2(0.0, 0.0);
uniform vec4 modulate : source_color;
uniform float x_buffer = 2.0;//Increase these if you need your shadow to stretch further
uniform float y_buffer = 2.0;

//uniform vec2 texture_size; //uncomment for GLES2

void vertex() {
	//This increases the size of the uv so the sprite can be drawn 'out of bounds'
	VERTEX.x *= x_buffer;
	VERTEX.y *= y_buffer;
}

void fragment() {

	//This part resizes your sprite back to normal after the uv adjustment
	vec2 uvTest = UV * 2.0 - 1.0;
	uvTest.x *= x_buffer;
	uvTest.x /= 1.0;
	uvTest.y *= y_buffer;
	uvTest.y /= 1.0;
	uvTest = (uvTest + 1.0) / 2.0;
	COLOR = texture(TEXTURE, uvTest);

	vec2 ps = TEXTURE_PIXEL_SIZE;
	vec2 uv = uvTest;
	float sizex = float(textureSize(TEXTURE,int(ps.x)).x); //comment for GLES2
	float sizey = float(textureSize(TEXTURE,int(ps.y)).y); //comment for GLES2
	//float sizex = texture_size.x; //uncomment for GLES2
	//float sizey = texture_size.y; //uncomment for GLES2
	uv.y+=offset.y*ps.y;
	uv.x+=offset.x*ps.x;
	float decalx=((uv.y-ps.x*sizex)*deform.x);
	float decaly=((uv.y-ps.y*sizey)*deform.y);
	uv.x += decalx;
	uv.y += decaly;
	vec4 shadow = vec4(modulate.rgb, texture(TEXTURE, uv).a * modulate.a);
	vec4 col = texture(TEXTURE, uvTest);
	COLOR = mix(shadow, col, col.a);
}
