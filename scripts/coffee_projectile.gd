extends Area2D

var speed = 600 # Mantendo a mesma velocidade que você usou no livro!
var direction = 1

func _process(delta):
	position.x += speed * direction * delta

func _on_body_entered(body):
	# Segurança: Ignora a própria Xícara e outros tiros de café
	if "Xícara" in body.name or "Coffee" in body.name:
		return
		
	# Se acertar a Yume, aplica o dano
	if body.name == "Yume" and body.has_method("take_damage"):
		body.take_damage()

	# Some ao bater na Yume ou no cenário/paredes
	queue_free()
