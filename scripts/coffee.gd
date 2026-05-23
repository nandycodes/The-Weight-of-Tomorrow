extends Area2D

# Defina o tipo do item no Inspector: mude para "livro" se criar um livro depois
@export_enum("vida", "livro") var tipo_do_item: String = "vida"
@export var quantidade: int = 1

@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	# Efeito visual: Faz o café flutuar de leve no chão
	position.y += sin(Time.get_ticks_msec() * 0.005) * 0.1

func _on_body_entered(body: Node2D) -> void:
	# Trava de segurança: Se o item de cenário raspar no chão/Terrain, ele IGNORE e não suma!
	if "Terrain" in body.name or "Cenario" in body.name:
		return
		
	# Se quem passar por cima for a Yume
	if body.name == "Yume":
		if tipo_do_item == "vida":
			# Usa 'health' que é a variável real em inglês dentro da sua Yume!
			body.health = min(body.health + quantidade, 5) 
			print("Yume tomou café e curou! Vida atual: ", body.health)
		elif tipo_do_item == "livro":
			body.quantidade_livros += quantidade
			print("Yume pegou livros! Total: ", body.quantidade_livros)
		
		# O item só some do mapa quando a Yume coleta!
		queue_free()
