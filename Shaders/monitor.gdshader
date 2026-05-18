shader_type canvas_item;

uniform float brilho : hint_range(0.0, 10.0) = 2.0;

void fragment() {
    vec4 cor = texture(TEXTURE, UV);
    // Isso aqui faz a mágica do brilho
    COLOR = vec4(cor.rgb * brilho, cor.a);
}