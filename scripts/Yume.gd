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

# --- LIVROS ---
var livros = 5 # Quantidade inicial de livros que a Yume começa


func _physics_process(delta):

	# Sistema de Diálogo: Trava a Yume se a tela de diálogo estiver ativa
	if get_tree().root.find_child("DialogScreen", true, true):
		velocity.x = 0
		if !is_on_floor():
			velocity.y += GRAVITY * delta 
		move_and_slide()
		anim.play("idle") 
		return 

	# Se estiver morta, impede movimentos normais
	if esta_morta:
		if !is_on_floor():
			velocity.y += GRAVITY * delta
		else:
			velocity.x = 0

		move_and_slide()
		return

	# Aplica gravidade normal
	if !is_on_floor():
		velocity.y += GRAVITY * delta


	# --- ATAQUE COMPLETO ---
	
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


	# --- TIRO DE LIVRO ---
	
	if Input.is_action_just_pressed("shoot") and !attacking and livros > 0:

		attacking = true
		livros -= 1 
		
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


	# --- MOVIMENTO E PULO ---
	
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_FORCE

	var direction = Input.get_axis("ui_left", "ui_right")

	if direction != 0:
		velocity.x = direction * SPEED
	else:
		velocity.x = 0

	move_and_slide()

	# Altera o lado do sprite baseado na direção
	if direction != 0:
		anim.flip_h = direction < 0

	# Controla as animações de locomoção
	if !is_on_floor():
		anim.play("jump")
	elif direction != 0:
		anim.play("run")
	else:
		anim.play("idle")


# --- FUNÇÃO DE MORTE ---
# Chamada quando a vida zera ou quando ela cai na água (water2)

func morrer():

	if esta_morta:
		return

	esta_morta = true
	invulneravel = true
	
	# Zera a velocidade para o lado, mas dá uma pequena queda (bom para o efeito de afundar)
	velocity.x = 0
	velocity.y = 200 

	anim.play("die") # Toca a animação dela morrendo

	await anim.animation_finished

	# Dá o restart na fase atual
	get_tree().reload_current_scene()


# --- RECEBER DANO ---

func take_damage():

	if esta_morta or invulneravel:
		return

	invulneravel = true
	health -= 1

	print("yume tomou dano:", health)

	modulate.a = 0.5 # Deixa a Yume transparente (efeito de piscada de dano)

	if health <= 0:
		morrer()
		return

	await get_tree().create_timer(1.0, false, false, true).timeout

	modulate.a = 1.0 # Volta a opacidade normal
	invulneravel = false


# --- FALLBACK DE SINAL ---

func _on_attack_area_body_entered(body):
	
	if body == self:
		return
		
	if attacking and body.has_method("take_damage"):
		body.take_damage()
