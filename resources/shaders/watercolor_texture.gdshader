shader_type spatial;
render_mode unshaded;

uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, filter_linear_mipmap;
uniform sampler2D NORMAL_TEXTURE : hint_normal_roughness_texture, filter_linear_mipmap;

uniform sampler2D noise_texture:repeat_enable;

uniform float damper: hint_range(0.0, 300.0, 5.0) = 250.0;

void vertex(){
	POSITION = vec4(VERTEX, 1.0);
	POSITION.z = 1.0;
}

void fragment() {
	
	vec3 noise_color = texture(noise_texture,SCREEN_UV).rgb;
	vec3 dampened_noise = texture(SCREEN_TEXTURE,SCREEN_UV + (noise_color.b / damper)).rgb;
	
	
	ALBEDO = dampened_noise;
	
}