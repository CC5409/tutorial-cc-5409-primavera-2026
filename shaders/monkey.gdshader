shader_type spatial;
//render_mode unshaded;

uniform float dist = 0.0;
uniform vec3 col: source_color;
uniform sampler2D tex: source_color, repeat_enable;
uniform float speed = 0.0;
uniform float power = 1.0;
uniform vec3 rim_color: source_color = vec3(1.0, 1.0, 1.0);
uniform bool fresnel_enabled = false;

void vertex() {
	VERTEX += NORMAL * dist * (sin(TIME) + 1.0) * 0.5;
}

void fragment() {
	vec2 uv = UV;
	uv.x += speed * TIME;
	ALBEDO = texture(tex, uv).rgb;
	float facing = clamp(dot(NORMAL, VIEW), 0.0, 1.0);
	float fresnel = pow(1.0 - facing, power);
	if(fresnel_enabled) {
		EMISSION = rim_color * fresnel;
		
		//if(fresnel > 0.01) discard;
	}
}

//void light() {
//	// Called for every pixel for every light affecting the material.
//	// Uncomment to replace the default light processing function with this one.
//}
