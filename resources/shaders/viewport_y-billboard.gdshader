shader_type spatial;

render_mode unshaded;
render_mode cull_disabled;

uniform sampler2D viewport_texture: hint_default_transparent;

void vertex() {
    // Get the direction vectors from the inverse view matrix (camera's orientation)
    // INV_VIEW_MATRIX[0] is the camera's right vector (X-axis)
    // INV_VIEW_MATRIX[2] is the camera's forward vector (Z-axis)

    // Normalize these vectors on the XZ plane so the object stays upright
    vec3 right_dir = normalize(INV_VIEW_MATRIX[0].xyz);
    vec3 forward_dir = normalize(INV_VIEW_MATRIX[2].xyz);

    // Discard the original vertex position's X and Z components relative to the origin
    // and rebuild them using the camera's XZ-plane directions.
    // VERTEX.y (up/down axis) remains unchanged, making it a Y-billboard.
    VERTEX = right_dir * VERTEX.x + INV_VIEW_MATRIX[1].xyz * VERTEX.y + forward_dir * VERTEX.z;
}


void fragment() {
	vec4 color = texture(viewport_texture, UV);
	ALBEDO = color.rgb;
	ALPHA = color.a;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
