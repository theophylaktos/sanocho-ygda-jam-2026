shader_type canvas_item;

void fragment() {
	COLOR.a = distance(UV, vec2(0.5, 0.5));
}