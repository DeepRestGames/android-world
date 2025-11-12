shader_type canvas_item;

render_mode blend_premul_alpha;

uniform float horizontal_coefficient : hint_range(0.0, 0.5, 0.01) = 0.09;
uniform float vertical_coefficient : hint_range(0.0, 0.5, 0.01) = 0.11;
uniform float softening_coefficient : hint_range(0.0, 3.0, 0.1) = 2.0;
uniform vec4 vignette_color : source_color;

void fragment() {

// Interleaved Gradient Noise
vec2 p_coord = SCREEN_UV / SCREEN_PIXEL_SIZE;
float ign = fract(52.9829189 * fract(dot(p_coord, vec2(0.06711056, 0.00583715))));
float ign_reduced = (ign * 0.3 + 1.0 - 0.3);
// Elliptical vignette with ign applied
float vignette_alpha = (((cos(UV.x*PI*2.0)+1.0/2.0)*horizontal_coefficient+(cos(UV.y*PI*2.0)+1.0/2.0)*vertical_coefficient)*softening_coefficient)*(ign_reduced);
// Elliptical vignette with ign applied and pulsing intensity
//COLOR.a = (((cos(SCREEN_UV.x*PI*2.0)+1.0/2.0)*horizontal_coefficient+(cos(SCREEN_UV.y*PI*2.0)+1.0/2.0)*vertical_coefficient)*softening_coefficient*(sin(TIME*5.0)+5.0/1.0))*(ign*0.5);

COLOR = vec4 (vignette_color.r, vignette_color.g, vignette_color.b, vignette_alpha);
// Looks great but it would look better if I could somehow blur it a bit
}