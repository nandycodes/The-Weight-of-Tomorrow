extends Area2D

@export var gate_path : NodePath

var activated = false
var player_near = false

func _process(_delta):

	if player_near and Input.is_action_just_pressed("interact") and !activated:

		activated = true

		$Label.visible = false

		$AnimationPlayer.play("lever_on")

		var gate = get_node(gate_path)

		gate.open_gate()

func _on_body_entered(body):

	if body.name == "Yume":

		player_near = true

		$Label.visible = true

func _on_body_exited(body):

	if body.name == "Yume":

		player_near = false

		$Label.visible = false
