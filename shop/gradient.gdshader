shader_type canvas_item;

void fragment() {
	COLOR.a = (UV.x - 0.3) * 0.7;
}
