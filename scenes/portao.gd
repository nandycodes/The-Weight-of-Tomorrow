extends StaticBody2D

func open_gate():
	print("O portão recebeu o comando da alavanca!")
	
	# 1. Esconde o portão fechado (que agora se chama Sprite2D2 na árvore)
	if has_node("Sprite2D2"):
		$Sprite2D2.visible = false
		
	# 2. Mostra o portão aberto (que se chama SpriteAberto na árvore)
	if has_node("SpriteAberto"):
		$SpriteAberto.visible = true
		
	# 3. Desativa a colisão para a Yume passar
	if has_node("CollisionShape2D"):
		$CollisionShape2D.disabled = true
