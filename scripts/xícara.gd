extends CharacterBody2D

const SPEED = 50
const GRAVITY = 900
const ATTACK_DISTANCE = 200 

@onready var anim = $AnimatedSprite2D
@onready var shoot_point = $ShootPoint # Referência ao ponto de tiro

const COFFEE_PROJECTILE = preload("res://entities/coffee_projectile.tscn")

var player = null
var attacking = false
var health = 3
var dead = false

func _physics_process(delta):
	# 1. Verifica se morreu
	if dead:
		return
		
	# 2. Aplica a gravidade
	if !is_on_floor():
		velocity.y += GRAVITY * delta

	# 3. Se a Yume NÃO estiver por perto, fica parada
	if player == null:
		velocity.x = 0
		if !attacking:
			anim.play("idle")
		move_and_slide()
		return

	# 4. Se a Yume ESTIVER por perto, calculamos a distância
	var direction = player.global_position.x - global_position.x
	var distance = global_position.distance_to(player.global_position)

	# --- NOVO CÓDIGO DE VIRA-VIRA ---
	# Se a Yume estiver na esquerda
	if direction < 0:
		anim.flip_h = true
		# Joga o ShootPoint para a esquerda (transforma o número em negativo)
		shoot_point.position.x = -abs(shoot_point.position.x)
	# Se a Yume estiver na direita
	else:
		anim.flip_h = false
		# Joga o ShootPoint para a direita (garante que o número é positivo)
		shoot_point.position.x = abs(shoot_point.position.x)
	# --------------------------------
	
	# 5. Lógica de andar e atirar
	if !attacking:
		if distance > ATTACK_DISTANCE:
			# Anda na direção do player
			velocity.x = sign(direction) * SPEED
			anim.play("jump")
		else:
			# Para de andar e atira
			velocity.x = 0
			attack()
			
	move_and_slide()

func attack():
	if dead or attacking:
		return
		
	attacking = true
	anim.play("attack")
	
	
	await get_tree().create_timer(0.4).timeout
	
	if dead: return 
	
	shoot() 
	
	await anim.animation_finished
	attacking = false

func shoot():
	if player == null:
		return
		
	
	var projectile = COFFEE_PROJECTILE.instantiate()
	
	
	get_parent().add_child(projectile)
	
	
	projectile.global_position = shoot_point.global_position
	
	
	var direction_to_player = (player.global_position - shoot_point.global_position).normalized()
	

	projectile.direction = direction_to_player

func take_damage():
	if dead:
		return
	health -= 1
	print("Xícara tomou dano:", health)
	if health <= 0:
		die()

func die():
	if dead:
		return
	dead = true
	velocity = Vector2.ZERO
	anim.play("die")
	await anim.animation_finished
	queue_free()

func _on_detection_area_body_entered(body: Node2D) -> void:
	if body.name == "Yume":
		player = body

func _on_detection_area_body_exited(body: Node2D) -> void:
	if body.name == "Yume":
		player = null
