shader_type spatial;

render_mode unshaded;
render_mode cull_disabled;

uniform sampler2D viewport_texture: hint_default_black;


void fragment() {
	vec4 color = texture(viewport_texture, UV);
	ALBEDO = color.rgb;
	//ALPHA = color.a;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
