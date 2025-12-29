shader_type spatial;
render_mode unshaded;

uniform sampler2D SCREEN_TEXTURE: hint_screen_texture, filter_linear_mipmap;
uniform sampler2D NORMAL_TEXTURE : hint_normal_roughness_texture, filter_linear_mipmap;

uniform sampler2D noise_texture:repeat_enable;

uniform float damper: hint_range(0.0, 300.0, 5.0) = 250.0;
uniform float color_intensity: hint_range(1.0, 10.0, 0.1) = 9.5;

uniform float lod: hint_range(0.0, 5.0, 0.01) = 2.7;
uniform float power_multiplier: hint_range(0.01,5.0,0.01) = 3.2;
uniform float max_dark: hint_range(0.1, 5.0, 0.1) = 4.0;
uniform float max_light: hint_range(0.0, 5.0, 0.1) = 2.0;

void vertex(){
	POSITION = vec4(VERTEX, 1.0);
	POSITION.z = 1.0;
}

void fragment() {
	vec2 uv = SCREEN_UV;
	
	vec3 screen_color = texture(SCREEN_TEXTURE, uv).rgb;
	vec3 normal = texture(NORMAL_TEXTURE, uv).rgb;
	
	// your code goes here!
	
	vec4 mask = texture(SCREEN_TEXTURE, SCREEN_UV);
	vec4 blur = texture(SCREEN_TEXTURE, SCREEN_UV, lod);
	blur = vec4(1.0 - 2.0* blur.rbg, blur.a);
	vec4 power_color = blur * pow(mask, vec4(power_multiplier));
	vec3 edges_result = (2.0 * (max_dark - max_light) * power_color).rgb;
	
	vec3 noise_color = texture(noise_texture,SCREEN_UV).rgb;
	vec3 dampened_noise = texture(SCREEN_TEXTURE,SCREEN_UV + (noise_color.b / damper)).rgb;
	normal = dampened_noise;
	vec3 modified_albedo = edges_result + dampened_noise;
	
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
	
	ALBEDO = new_color * modified_albedo;
	
}