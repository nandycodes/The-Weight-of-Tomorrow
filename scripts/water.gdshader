shader_type canvas_item;

uniform float intensidade : hint_range(0.0, 1.0) = 0.5;

void fragment() {
    
    float alpha = smoothstep(0.0, intensidade, 1.0 - UV.y);
    
    
    COLOR = vec4(0.1, 0.0, 1.2, 1.4 - alpha);
}