shader_type spatial;
render_mode unshaded;

uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, filter_linear_mipmap;
uniform sampler2D NORMAL_TEXTURE : hint_normal_roughness_texture, filter_linear_mipmap;

uniform sampler2D noise_texture:repeat_enable;

uniform float damper: hint_range(0.0, 300.0, 5.0) = 250.0;

uniform float color_intensity: hint_range(1.0, 10.0, 0.01) = 3.0;

void vertex(){
	POSITION = vec4(VERTEX, 1.0);
	POSITION.z = 1.0;
}

void fragment() {
	vec2 uv = SCREEN_UV;

	vec3 noise_color = texture(noise_texture,uv).rgb;
	vec3 dampened_noise = texture(SCREEN_TEXTURE,uv + (noise_color.b / damper)).rgb;

	vec3 red_only = dampened_noise * vec3(1,0,0);
	vec3 blue_only = dampened_noise * vec3(0,0,1);
	vec3 green_only = dampened_noise * vec3(0,1,0);

	vec3 cyan = 1.0 - red_only;
	vec3 yellow = 1.0 - blue_only;
	vec3 magenta = 1.0 - green_only;

	vec3 red = (magenta * yellow);
	vec3 blue = (cyan * magenta);
	vec3 green = (yellow * cyan);

	vec3 new_color = color_intensity - vec3(red+blue+green);

	ALBEDO = new_color;

}