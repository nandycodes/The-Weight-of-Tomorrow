extends PointLight2D

# Variáveis para você ajustar no Inspetor sem precisar mexer no código
@export var velocidade: float = 10.0
@export var intensidade_min: float = 0.6
@export var intensidade_max: float = 1.2

func _process(_delta):
	# randf_range gera um número aleatório entre o min e o max a cada frame
	# Isso cria aquele efeito de 'tremidinho' na luz
	energy = randf_range(intensidade_min, intensidade_max)
	
	# Opcional: Se quiser que a luz mude de cor levemente (como se o vídeo mudasse)
	# color.a = randf_range(0.5, 1.0)
