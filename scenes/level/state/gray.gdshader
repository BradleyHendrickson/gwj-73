shader_type canvas_item;

uniform bool active = false;

void fragment() {
	// Replaces all but alpha to white if active = true
	vec4 original_color = texture(TEXTURE, UV);
	float new_gray = (original_color.r + original_color.g + original_color.b)/3.0;
	vec4 gray_color = vec4(new_gray, new_gray, new_gray, original_color.a);
	vec4 new_color = original_color;
	if (active == true)
	{
		new_color = gray_color;
	}
	COLOR = new_color;
}