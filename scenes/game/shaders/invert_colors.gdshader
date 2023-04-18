shader_type canvas_item;

uniform bool hide = false;
uniform vec4 color : source_color = vec4(1);
uniform float strength = 0.2;

uniform sampler2D screen_texture : hint_screen_texture, repeat_disable, filter_nearest;

void fragment(){
	vec4 pixel = texture(screen_texture, SCREEN_UV);
        COLOR = pixel;
	if (hide == false){ 
		
		vec3 grayscale_value = vec3(dot(pixel.rgb, vec3(0.299, 0.587, 0.114)));
		float range = 1.0 - step(distance(pixel.rgb, color.rgb), strength);
		COLOR.rgb = mix(pixel.rgb, grayscale_value, range);
	}
	
}