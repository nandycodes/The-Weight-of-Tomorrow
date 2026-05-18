extends CharacterBody2D

const SPEED = 230
const JUMP_FORCE = -380
const GRAVITY = 900

@onready var anim = $AnimatedSprite2D
@export var projectile_scene : PackedScene

var attacking = false
var esta_morta = false # <-- ADICIONADO: Controle para saber se ela morreu

func _physics_process(delta):

	# <-- ADICIONADO: Se ela estiver morta, para o script aqui e impede movimentação/inputs
	if esta_morta:
		if !is_on_floor():
			velocity.y += GRAVITY * delta # Permite que o corpo caia se morrer no ar
		else:
			velocity.x = 0
		move_and_slide()
		return # Importante: corta o resto da função para não rodar os comandos abaixo

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

		# pequeno atraso pra bater com o frame da animação
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


# =================================================================
# <-- BLOCCO DE FUNÇÕES ADICIONADAS PARA A LOGICA DE MORTE
# =================================================================

func morrer():
	if esta_morta:
		return # Evita ativar a morte duas vezes seguidas
		
	esta_morta = true
	velocity.x = 0 # Zera a velocidade horizontal imediatamente
	
	anim.play("die") # Toca a animação dela caindo de joelhos
	
	# Conecta o sinal para avisar quando a animação "die" chegar ao fim
	if not anim.animation_finished.is_connected(_on_animacao_morte_terminou):
		anim.animation_finished.connect(_on_animacao_morte_terminou)

func _on_animacao_morte_terminou():
	if anim.animation == "die":
		# Recarrega a cena atual imediatamente (Temporário para testes)
		get_tree().reload_current_scene()
