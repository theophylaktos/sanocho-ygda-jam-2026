shader_type canvas_item;

uniform vec4 line_color: source_color = vec4(1);
uniform bool is_outlined = false;
const float max_line_thickness = 2.0;
void fragment() {
	if ((float(is_outlined) / 2.0) > 0.0)
	{
		vec4 color = texture(TEXTURE, UV);
		float outline = color.a;
		vec2 size = TEXTURE_PIXEL_SIZE * (float(is_outlined) / 2.0) * max_line_thickness;
		
		for (float y = -1.0; y <= 1.0; y++)
		{
			for (float x = -1.0; x <= 1.0; x++)
			{
				vec2 offset = vec2(x,y) * size;
				outline += texture(TEXTURE, UV + offset).a;
			}
		}
		
		outline = min(outline, 1.0);
		COLOR = mix(color, line_color, outline - color.a);
	}
}