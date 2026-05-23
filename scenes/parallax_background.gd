extends ParallaxBackground

# Velocidade de movimento das nuvens
@export var velocidade_nuvens = 50.0

func _process(delta):
	# Incrementa o offset no eixo X para criar o movimento infinito
	scroll_offset.x -= velocidade_nuvens * delta
