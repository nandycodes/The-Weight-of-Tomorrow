extends Area2D

var direction = Vector2.ZERO 

func _process(delta):
	# 1. Motor de movimento
	global_position += direction * 600 * delta
	
	# 2. Faz o café rotacionar para olhar para a direção do movimento
	if direction != Vector2.ZERO:
		rotation = direction.angle()

func _on_body_entered(body):
	# Se bater no Terrain, o código simplesmente ignora
	if "Terrain" in body.name:
		return 

	# Se bater na Yume: causa dano e DESATIVA a colisão
	if body.name == "Yume":
		if body.has_method("take_damage"):
			body.take_damage()
		
		# Desativa a colisão para parar de bater
		$CollisionShape2D.set_deferred("disabled", true)
		
		# Esconde a imagem (usando AnimatedSprite2D)
		if has_node("AnimatedSprite2D"):
			$AnimatedSprite2D.visible = false
		
		# Aguarda um segundo para o tiro sumir de verdade
		await get_tree().create_timer(1.0).timeout
		queue_free()
