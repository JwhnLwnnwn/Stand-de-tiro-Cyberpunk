shader_type canvas_item;
render_mode unshaded;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

// --- COR ---
uniform float brightness = 1.0;
uniform float contrast   = 1.05;
uniform float saturation = 1.05;
uniform float gamma      = 1.0;

// --- SCANLINE ---
uniform float scanline_strength = 0.05;
uniform float scanline_density  = 0.1;
uniform float scanline_speed    = 0.5;

// --- MOVIMENTO ---
uniform float jitter_px = 0.1;
uniform float wobble_px = 0.2;

// --- GLOW ---
uniform float glow_strength  = 0.4;
uniform float glow_threshold = 0.7;

// --- VINHETA ---
uniform float vignette_strength = 0.5;
uniform float vignette_softness = 0.1;

vec3 apply_color(vec3 c) {
	c *= brightness;
	c = mix(vec3(0.5), c, contrast);

	float l = dot(c, vec3(0.299, 0.587, 0.114));
	c = mix(vec3(l), c, saturation);

	c = pow(c, vec3(1.0 / max(gamma, 0.0001)));
	return c;
}

vec3 sample_screen(vec2 uv) {
	return textureLod(screen_texture, uv, 0.0).rgb;
}

float hash(float n) {
	return fract(sin(n) * 43758.5453);
}

void fragment() {
	vec2 px = SCREEN_PIXEL_SIZE;
	vec2 uv = SCREEN_UV;
	float t = TIME;

	// --- JITTER por linha ---
	float y = floor(uv.y / px.y);
	float j = (hash(y + floor(t * 10.0)) - 0.5);
	uv.x += j * jitter_px * px.x;

	// --- WOBBLE leve ---
	uv.x += sin(uv.y * 6.0 + t * 1.2) * wobble_px * px.x;

	vec3 col = sample_screen(uv);

	// --- proteção de texto ---
	float lum = dot(col, vec3(0.299, 0.587, 0.114));
	vec3 original = col;
	float reduce = smoothstep(0.5, 0.9, lum);
	col = mix(col, original, reduce);

	// --- scanline animada ---
	float scan = sin((uv.y / px.y) * 3.14159 * scanline_density + t * scanline_speed * 10.0);
	float scan_mul = 1.0 - scanline_strength * (0.5 - 0.5 * scan);
	col *= scan_mul;

	// --- glow leve ---
	vec3 c0 = col;
	vec3 cx1 = sample_screen(uv + vec2(px.x, 0.0));
	vec3 cx2 = sample_screen(uv - vec2(px.x, 0.0));
	vec3 cy1 = sample_screen(uv + vec2(0.0, px.y));
	vec3 cy2 = sample_screen(uv - vec2(0.0, px.y));

	vec3 blur = (c0 + cx1 + cx2 + cy1 + cy2) / 5.0;

	float br = dot(blur, vec3(0.299, 0.587, 0.114));
	vec3 glow = max(blur - vec3(glow_threshold), vec3(0.0));

	col += glow * glow_strength * (0.5 + 0.5 * br);

	// --- VINHETA ---
	vec2 center = uv - 0.5;
	float dist = length(center);
	float vignette = smoothstep(vignette_softness, 0.8, dist);
	col *= (1.0 - vignette * vignette_strength);

	col = apply_color(col);

	COLOR = vec4(col, 1.0);
}