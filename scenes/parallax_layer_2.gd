extends ParallaxLayer

# Aqui você escolhe a velocidade. 
# Números negativos (ex: -50) vão para a esquerda.
@export var velocidade : float = -50.0

func _process(delta):
	# Isso aqui move a "falsa posição" da camada
	motion_offset.x += velocidade * delta
