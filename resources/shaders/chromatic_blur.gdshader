shader_type canvas_item;

uniform sampler2D viewport_texture: hint_screen_texture, filter_linear_mipmap;

uniform float lod: hint_range(0.0, 1.5, 0.1) = 0.0;

uniform float displace_r: hint_range(-25.0, 25.0, 0.1) = 0.0;
uniform float displace_b: hint_range(-25.0, 25.0, 0.1) = 0.0;


void fragment(){
	vec2 r_displacement = vec2(displace_r, 0.0);
	vec2 b_displacement = vec2(-displace_b, 0.0);
	vec2 g_displacement = vec2(0.0, 0.0);
	
	float r = textureLod(viewport_texture, SCREEN_UV + vec2(SCREEN_PIXEL_SIZE*r_displacement), lod).r;
	float g = textureLod(viewport_texture, SCREEN_UV + vec2(SCREEN_PIXEL_SIZE*g_displacement), lod).g;
	float b = textureLod(viewport_texture, SCREEN_UV + vec2(SCREEN_PIXEL_SIZE*b_displacement), lod).b;
	
	COLOR = vec4(r, g, b, 1.0);
}