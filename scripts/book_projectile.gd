extends Area2D

var speed = 600
var direction = 1

func _process(delta):
	position.x += speed * direction * delta

func _on_body_entered(body):
	# Impede que o livro cause dano na própria Yume na hora do disparo
	if body.name == "Yume":
		return

	# Se o livro bater em um inimigo (Zumbi, Xícara, etc.) que tem a função de dano
	if body.has_method("take_damage"):
		body.take_damage()

	# Para o livro e remove ele do jogo 
	queue_free()


func _on_visible_on_screen_notifier_2d_screen_exited():
	
	queue_free()
