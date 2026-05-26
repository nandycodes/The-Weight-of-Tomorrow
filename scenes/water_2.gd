extends Area2D

func _ready() -> void:
	# Conecta o sinal de colisão automaticamente
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node2D) -> void:
	# Verifica se quem caiu na água é a Yume
	if body.name == "Yume": 
		# Se a Yume tiver a função morrer(), o jogo ativa ela
		if body.has_method("morrer"):
			body.morrer()
