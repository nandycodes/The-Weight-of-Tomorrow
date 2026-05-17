extends StaticBody2D

@export var lever_path : NodePath

var triggered = false

func open_gate():

	$AnimationPlayer.play("gate_open")

	$CollisionShape2D.set_deferred("disabled", true)

	var camera = get_tree().get_first_node_in_group("camera")

	if camera:

		camera.limit_right = 6000

func _on_gate_trigger_body_entered(body):

	if body.name == "Yume" and !triggered:

		triggered = true

		print("Talvez eu deva dar uma olhada ao redor...")

		var lever = get_node(lever_path)

		lever.visible = true
