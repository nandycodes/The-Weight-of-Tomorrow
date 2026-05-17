extends CharacterBody2D

const SPEED = 230
const JUMP_FORCE = -380
const GRAVITY = 900

@onready var anim = $AnimatedSprite2D
@export var projectile_scene : PackedScene

var attacking = false

func _physics_process(delta):

	# gravidade
	if !is_on_floor():
		velocity.y += GRAVITY * delta

	# ataque da bolsa
	if Input.is_action_just_pressed("attackb") and !attacking:

		attacking = true

		anim.play("attack_bag")

		await anim.animation_finished

		attacking = false

	# tiro do livro
	if Input.is_action_just_pressed("shoot") and !attacking:

		attacking = true

		anim.play("attack_book")

		var projectile = projectile_scene.instantiate()

		get_parent().add_child(projectile)

		projectile.position = position

		if anim.flip_h:

			projectile.direction = -1

		else:

			projectile.direction = 1

		await anim.animation_finished

		attacking = false

	# impede movimentação atacando
	if attacking:

		move_and_slide()

		return

	# pulo
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_FORCE

	# movimento
	var direction = Input.get_axis("ui_left", "ui_right")

	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = 0

	move_and_slide()

	# virar sprite
	if direction != 0:
		anim.flip_h = direction < 0

	# animações
	if !is_on_floor():

		anim.play("jump")

	elif direction != 0:

		anim.play("run")

	else:

		anim.play("idle")
