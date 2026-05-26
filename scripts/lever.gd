extends Area2D

# Aqui você vai arrastar o seu nó do portão no Inspetor (na direita)
@export var gate : Node2D  

var activated = false
var player_near = false

func _process(_delta):
	if player_near and Input.is_action_just_pressed("interact") and !activated:
		activated = true
		$Label.visible = false
		$AnimationPlayer.play("lever_on")
		
		# Verificamos se você lembrou de arrastar o portão no Inspetor
		if gate != null:
			gate.open_gate()
		else:
			print("Erro: Você esqueceu de arrastar o portão no Inspetor da Alavanca!")

func _on_body_entered(body):
	if body.name == "Yume":
		player_near = true
		$Label.visible = true

func _on_body_exited(body):
	if body.name == "Yume":
		player_near = false
		$Label.visible = false
