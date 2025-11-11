shader_type canvas_item;

//render_mode blend_mul;


void fragment() {
	
	// Interleaved Gradient Noise
	vec2 p_coord = SCREEN_UV / SCREEN_PIXEL_SIZE;
	float ign = fract(52.9829189 * fract(dot(p_coord, vec2(0.06711056, 0.00583715))));
	float ign_reduced = (ign * 0.5 + 1.0 - 0.5);

	vec4 pixelColor = texture(TEXTURE, UV*2.0);
	COLOR = vec4(pixelColor.rgb, pixelColor.a);
	
}