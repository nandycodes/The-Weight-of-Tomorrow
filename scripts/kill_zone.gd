extends Area2D

func _on_body_entered(body):
	# Se quem caiu aqui for a Yume, ativa a morte dela
	if body.name == "Yume" and body.has_method("morrer"):
		body.morrer()
