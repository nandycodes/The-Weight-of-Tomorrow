extends Area2D  # <-- ESSA LINHA É OBRIGATÓRIA! Ela resolve o erro do queue_free()

# Como esse é o item de livro, definimos o tipo padrão para "livro"
@export_enum("vida", "livro") var tipo_do_item: String = "livro"
@export var quantidade: int = 3 # Quantidade de munição que a Yume ganha ao pegar

func _process(_delta: float) -> void:
	# Efeito visual idêntico ao do café: fica flutuando no chão
	position.y += sin(Time.get_ticks_msec() * 0.005) * 0.1

func _on_body_entered(body: Node2D) -> void:
	# Trava de segurança para ignorar o chão/Terrain caso a Mask falhe
	if "Terrain" in body.name or "Cenario" in body.name:
		return
		
	# Se quem passar por cima for a Yume
	if body.name == "Yume":
		if tipo_do_item == "livro":
			# Ajustado para usar 'livros', que é a variável real do script da Yume!
			body.livros += quantidade
			print("Yume pegou livros! Total no estoque: ", body.livros)
			
		elif tipo_do_item == "vida":
			body.health = min(body.health + quantidade, 5)
		
		# Agora o comando vai funcionar perfeitamente porque o script extends Area2D
		queue_free()
