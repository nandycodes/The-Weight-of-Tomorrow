extends Area2D

var speed = 300
var direction = Vector2.DOWN

func _ready():
	body_entered.connect(_on_body_entered)
	area_entered.connect(_on_area_entered)
	
	# Garante que o projétil seja removido após 5 segundos (fallback)
	await get_tree().create_timer(5.0).timeout
	if is_instance_valid(self):
		queue_free()

func _physics_process(delta):
	position += direction * speed * delta
	
	# Remove se sair da tela
	if position.y > get_viewport().size.y + 100:
		queue_free()
	if position.y < -100:
		queue_free()
	if position.x > get_viewport().size.x + 100:
		queue_free()
	if position.x < -100:
		queue_free()

func _on_body_entered(body):
	if not is_instance_valid(body):
		return
		
	if body.name == "Yume":
		if body.has_method("hit_by_projectile"):
			body.hit_by_projectile()
		elif body.has_method("take_damage"):
			body.take_damage()
		explode()
	elif body.name == "Billet":
		# Projétil não danifica o Billet (só as perguntas)
		queue_free()

func _on_area_entered(area):
	# Se colidir com outro projétil, só some
	queue_free()

func explode():
	if not is_instance_valid(self):
		return
	# Pequeno efeito visual
	modulate = Color.RED
	scale = Vector2(0.5, 0.5)
	await get_tree().create_timer(0.1).timeout
	if is_instance_valid(self):
		queue_free()
		
		
