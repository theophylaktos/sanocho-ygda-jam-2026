shader_type canvas_item;

uniform bool enabled = false;

void fragment() {
	COLOR.r += 0.2 * float(enabled);
	COLOR.gb -= 0.2 * float(enabled);
}