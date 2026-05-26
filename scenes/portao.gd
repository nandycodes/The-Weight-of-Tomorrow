extends StaticBody2D

func _ready():
	# Garante que começa com o fechado aparecendo e o aberto sumido
	if has_node("Sprite2D"):
		$Sprite2D.visible = true
	if has_node("Sprite2D2"):
		$Sprite2D2.visible = false

func open_gate():
	print("O portão recebeu o comando da alavanca e está abrindo!")
	
	# 1. Esconde o fechado
	if has_node("Sprite2D"):
		$Sprite2D.visible = false
		
	# 2. Mostra o aberto
	if has_node("Sprite2D2"):
		$Sprite2D2.visible = true
		
	# 3. Desativa a colisão
	if has_node("CollisionShape2D"):
		$CollisionShape2D.disabled = true
