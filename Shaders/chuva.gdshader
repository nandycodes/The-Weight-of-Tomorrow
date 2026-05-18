shader_type canvas_item;

uniform float velocidade = 1.0;
uniform float intensidade = 0.5;

void fragment() {
    // Cria linhas finas que se movem rápido para baixo
    float chuva = step(0.98, fract(sin(dot(UV.xx + floor(UV.y * 20.0), vec2(12.9, 78.2))) * 437.5 + TIME * velocidade));
    vec4 cor_original = texture(TEXTURE, UV);
    COLOR = vec4(cor_original.rgb + (chuva * intensidade), cor_original.a);
}