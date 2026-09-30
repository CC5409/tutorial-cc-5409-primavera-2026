shader_type spatial;
render_mode unshaded, cull_front;

uniform float outline_width = 0.03;
uniform vec3 outline_color: source_color;

void vertex() {
	VERTEX += NORMAL * outline_width;
}

void fragment() {
	ALBEDO = outline_color;
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
