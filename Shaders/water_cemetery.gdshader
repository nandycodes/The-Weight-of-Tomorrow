shader_type canvas_item;

uniform float intensidade : hint_range(0.0, 1.0) = 0.5;

void fragment() {
	// UV.y puro deixa escuro embaixo e claro em cima!
	float alpha_degrade = smoothstep(0.0, intensidade, UV.y);
	
	// Tom do Verde-Musgo bem sombrio
	vec3 cor_verde = vec3(0.01, 0.14, 0.04);
	
	// Transparência base para conseguir ver as espumas passando
	float transparencia_base = 0.60;
	
	// Junta tudo aplicando a transparência invertida
	COLOR = vec4(cor_verde * alpha_degrade, transparencia_base * alpha_degrade);
}