shader_type canvas_item;

uniform vec4 glow_color : source_color = vec4(1.0, 0.1, 0.6, 1.0);
uniform float glow_size = 2.0;
uniform float glow_intensity = 0.0; // começa desligado

void fragment() {
	vec4 text = texture(TEXTURE, UV);

	vec4 glow = vec4(0.0);

	for (float x = -glow_size; x <= glow_size; x++) {
		for (float y = -glow_size; y <= glow_size; y++) {
			vec2 offset = vec2(x, y) * TEXTURE_PIXEL_SIZE;
			glow += texture(TEXTURE, UV + offset);
		}
	}

	glow /= pow((glow_size * 2.0 + 1.0), 2.0);
	glow *= glow_color * glow_intensity;

	COLOR = text + glow;
}