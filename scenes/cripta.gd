extends Node2D

@onready var anim_player = $AnimationPlayer
@onready var timer = $Timer

# Essa é a função que o Godot acabou de criar quando você conectou!
func _on_timer_timeout() -> void:
	# Quando o tempo acabar, toca a animação do zumbi saindo!
	if anim_player:
		anim_player.play("open_cripta")	

func _on_gatlh_body_entered(body: Node2D) -> void:
	# ATENÇÃO: O nome aqui tem que ser EXATAMENTE igual ao do nó da Yume 
	# (com maiúsculas e minúsculas certinhas)
	if body.name == "Yume":
		$cripta/Timer.start()

func _on_gatilhocripta_body_entered(body: Node2D) -> void:
	pass # Replace with function body.
