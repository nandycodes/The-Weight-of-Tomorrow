extends CharacterBody2D

var health = 5
var original_color
var original_position

func _ready():
	original_color = modulate
	original_position = position

func take_damage():
	health -= 1
	
	# Efeito visual de dano
	modulate = Color.RED
	scale = Vector2(1.2, 1.2)
	await get_tree().create_timer(0.1).timeout
	modulate = original_color
	scale = Vector2(1, 1)
	
	# Pequeno recuo
	position.x -= 10
	await get_tree().create_timer(0.1).timeout
	position = original_position
	
	if health <= 0:
		defeated()

func defeated():
	# Animação de derrota
	for i in range(5):
		modulate = Color.RED if i % 2 == 0 else Color.WHITE
		scale = Vector2(1.1, 1.1)
		await get_tree().create_timer(0.1).timeout
	
	modulate = Color.TRANSPARENT
	await get_tree().create_timer(0.5).timeout
	queue_free()
