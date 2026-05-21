extends Node2D

# Pega a referência do seu AnimationPlayer do HUD
@onready var animation_player: AnimationPlayer = $HUD/AnimationPlayer

func _ready() -> void:
	# Garante que o quadrado preto comece totalmente invisível no início do jogo
	$HUD/ColorRect.modulate.a = 0.0
	
	# Conecta o sinal da sua caixinha de diálogo para saber quando ela terminar
	if has_node("HUD/DialogScreen"):
		$HUD/DialogScreen.dialogo_fechou.connect(_on_dialogo_terminou)

func _on_dialogo_terminou() -> void:
	# 1. Roda a animação para começar a escurecer a tela
	animation_player.play("fade_to_black")
	
	# 2. Em vez de esperar o final da animação, espera apenas o tempo exato que você quiser!
	# "get_tree().create_timer(1.1)" faz o jogo pausar por 1.1 segundos.
	# Como sua animação dura 1.0 segundo, com 1.1 ela fica só um "piscar de olhos" no preto.
	await get_tree().create_timer(1.1).timeout
	 
	# 3. Troca instantaneamente para a floresta
	get_tree().change_scene_to_file("res://scenes/florest.tscn")
