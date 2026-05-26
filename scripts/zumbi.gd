extends CharacterBody2D

const SPEED = 50
const GRAVITY = 900
const ATTACK_DISTANCE = 40

@onready var anim = $AnimatedSprite2D

var player = null
var attacking = false
var health = 3
var dead = false


func _physics_process(delta):

	if dead:
		return

	if !is_on_floor():
		velocity.y += GRAVITY * delta

	if player == null:
		velocity.x = 0
		if !attacking:
			anim.play("idle")
		move_and_slide()
		return

	var direction = player.global_position.x - global_position.x
	var distance = abs(direction)

	anim.flip_h = direction < 0

	if !attacking:

		if distance > ATTACK_DISTANCE:
			velocity.x = sign(direction) * SPEED
			anim.play("walk")

		else:
			velocity.x = 0
			attack()

	move_and_slide()



# ATAQUE


func attack():

	if dead:
		return

	attacking = true
	anim.play("attack")

	await get_tree().create_timer(0.4).timeout

	if player != null and player.has_method("take_damage") and !player.esta_morta:
		player.take_damage()

	await anim.animation_finished

	attacking = false



# DETECÇÃO


func _on_area_2d_body_entered(body):

	if body.name == "Yume":
		player = body


func _on_area_2d_body_exited(body):

	if body.name == "Yume":
		player = null



# DANO


func take_damage():

	if dead:
		return

	health -= 1
	print("Zumbi tomou dano:", health)

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
