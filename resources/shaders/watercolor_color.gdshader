shader_type spatial;
render_mode unshaded;

uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, filter_linear_mipmap;

uniform float color_intensity: hint_range(1.0, 10.0, 0.01) = 3.0;

void vertex(){
	POSITION = vec4(VERTEX.xy, 1.0, 1.0);
	POSITION.z = 1.0;
}

void fragment() {
	vec2 uv = SCREEN_UV;

	vec3 red_only = texture(SCREEN_TEXTURE, uv).rgb * vec3(1,0,0);
	vec3 blue_only = texture(SCREEN_TEXTURE, uv).rgb * vec3(0,0,1);
	vec3 green_only = texture(SCREEN_TEXTURE, uv).rgb * vec3(0,1,0);

	vec3 cyan = 1.0 - red_only;
	vec3 yellow = 1.0 - blue_only;
	vec3 magenta = 1.0 - green_only;

	vec3 red = (magenta * yellow);
	vec3 blue = (cyan * magenta);
	vec3 green = (yellow * cyan);

	vec3 new_color = color_intensity - vec3(red+blue+green);

	ALBEDO = new_color;

}