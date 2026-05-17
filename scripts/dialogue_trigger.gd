extends Area2D

@export var lever_path : NodePath

var triggered = false

func _on_body_entered(body):

	if body.name == "Yume" and !triggered:

		triggered = true

		print("Talvez eu deva dar uma olhada ao redor...")

		var lever = get_node(lever_path)

		lever.visible = true
