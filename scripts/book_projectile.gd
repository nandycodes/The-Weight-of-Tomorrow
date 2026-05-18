extends Area2D

var speed = 600
var direction = 1

func _process(delta):

	position.x += speed * direction * delta
