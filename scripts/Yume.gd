extends CharacterBody2D

const SPEED = 230
const JUMP_FORCE = -380
const GRAVITY = 900

@onready var anim = $AnimatedSprite2D
@export var projectile_scene : PackedScene
@onready var attack_area = $AttackArea

var attacking = false
var esta_morta = false

var health = 5
var invulneravel = false


func _physics_process(delta):

	if esta_morta:
		if !is_on_floor():
			velocity.y += GRAVITY * delta
		else:
			velocity.x = 0

		move_and_slide()
		return

	if !is_on_floor():
		velocity.y += GRAVITY * delta


	#  ATAQUE
	
	if Input.is_action_just_pressed("attackb") and !attacking:

		attacking = true
		attack_area.monitoring = true

		anim.play("attack_bag")

		await get_tree().process_frame

		for body in attack_area.get_overlapping_bodies():
			
			if body == self:
				continue

			if body.has_method("take_damage"):
				body.take_damage()

				if body.has_method("apply_knockback"):
					var dir = sign(body.global_position.x - global_position.x)
					body.apply_knockback(dir)

				
				get_tree().paused = true
				await get_tree().create_timer(0.05, false, false, true).timeout
				get_tree().paused = false

		await anim.animation_finished

		attack_area.monitoring = false
		attacking = false


	# TIRO
	
	if Input.is_action_just_pressed("shoot") and !attacking:

		attacking = true
		anim.play("attack_book")

		await get_tree().create_timer(0.50).timeout

		var projectile = projectile_scene.instantiate()
		get_parent().add_child(projectile)

		projectile.global_position = global_position

		if anim.flip_h:
			projectile.direction = -1
		else:
			projectile.direction = 1

		await anim.animation_finished
		attacking = false


	if attacking:
		move_and_slide()
		return


	# MOVIMENTO
	
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_FORCE

	var direction = Input.get_axis("ui_left", "ui_right")

	if direction != 0:
		velocity.x = direction * SPEED
	else:
		velocity.x = 0

	move_and_slide()

	if direction != 0:
		anim.flip_h = direction < 0

	if !is_on_floor():
		anim.play("jump")
	elif direction != 0:
		anim.play("run")
	else:
		anim.play("idle")


# MORTE

func morrer():

	if esta_morta:
		return

	esta_morta = true
	invulneravel = true
	velocity = Vector2.ZERO

	anim.play("die")

	await anim.animation_finished

	get_tree().reload_current_scene()


# DANO

func take_damage():

	if esta_morta or invulneravel:
		return

	invulneravel = true
	health -= 1

	print("yume tomou dano:", health)

	modulate.a = 0.5

	if health <= 0:
		morrer()
		return


	await get_tree().create_timer(1.0, false, false, true).timeout

	modulate.a = 1.0
	invulneravel = false


# FALLBACK

func _on_attack_area_body_entered(body):
	
	if body == self:
		return
		
	if attacking and body.has_method("take_damage"):
		body.take_damage()
