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

# --- ADICIONADO AQUI ---
var livros = 5 # Quantidade inicial de livros que a Yume começa

# --- NOVAS VARIÁVEIS PARA O QUIZ/DESVIO ---
var can_dodge = false  # Habilita movimento de desvio durante chuva de projéteis
var dodge_speed = 400  # Velocidade mais rápida para desviar
var original_speed = SPEED
var original_gravity = GRAVITY

# 🔥 TELA PRETA PARA EFEITO DE MORTE
var black_screen: ColorRect = null

func _ready():
	# Cria a tela preta por código
	_criar_tela_preta()

func _criar_tela_preta():
	black_screen = ColorRect.new()
	black_screen.name = "BlackScreen"
	black_screen.color = Color.BLACK
	black_screen.z_index = 1000  # 🔥 Z-index bem alto para ficar na frente
	black_screen.modulate.a = 0  # Começa invisível
	
	# 🔥 Configura para cobrir a tela toda independente do tamanho
	black_screen.set_anchors_and_offsets_preset(Control.PRESET_FULL_RECT)
	
	# Precisa adicionar em um CanvasLayer para garantir que cubra tudo
	var canvas = CanvasLayer.new()
	canvas.layer = 100
	canvas.add_child(black_screen)
	add_child(canvas)
	
	print("✅ Tela preta criada e configurada")

func _physics_process(delta):
	
	# --- VERIFICA SE ESTÁ EM DIÁLOGO (QUIZ) ---
	if get_tree().root.find_child("DialogScreen", true, false):
		velocity.x = 0
		if !is_on_floor():
			velocity.y += GRAVITY * delta
		move_and_slide()
		anim.play("idle") 
		return 
	
	# --- MODO DESVIO (CHUVA DE PROJÉTEIS) ---
	if can_dodge and not esta_morta:
		# Modo desvio: só movimento horizontal, sem gravidade, sem ataques
		var direction = Input.get_axis("ui_left", "ui_right")
		if direction != 0:
			velocity.x = direction * dodge_speed
		else:
			velocity.x = 0
		velocity.y = 0
		
		move_and_slide()
		
		# Animação de corrida
		if direction != 0:
			anim.flip_h = direction < 0
			anim.play("run")
		else:
			anim.play("idle")
		
		return  # Sai do _physics_process para não processar outras ações

	# --- MODO NORMAL ---
	if esta_morta:
		if !is_on_floor():
			velocity.y += GRAVITY * delta
		else:
			velocity.x = 0
		move_and_slide()
		return

	if !is_on_floor():
		velocity.y += GRAVITY * delta

	#   ATAQUE
	
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


# --- NOVA FUNÇÃO: MODO DESVIO ATIVADO PELO QUIZ ---
func start_dodge_mode():
	if esta_morta:
		return
	can_dodge = true
	print("Yume pode desviar! Use A/D ou setas")
	await get_tree().create_timer(3.0).timeout
	can_dodge = false
	print("Yume não pode mais desviar")


# ============ MORTE COM EFEITO DE TELA PRETA ============
func morrer():
	if esta_morta:
		return
	esta_morta = true
	invulneravel = true
	can_dodge = false
	velocity = Vector2.ZERO
	
	# 🔥 Toca animação de morte
	anim.play("die")
	
	# 🔥 Escurece a tela durante a animação
	if black_screen:
		var tween = create_tween()
		tween.tween_property(black_screen, "modulate:a", 1.0, 0.5)
	
	await anim.animation_finished
	
	# 🔥 Aguarda o fade terminar
	await get_tree().create_timer(0.2).timeout
	
	# 🔥 Chama o Game Over
	GameManager.game_over()
# ==========================================


# DANO

func take_damage():
	if esta_morta or invulneravel:
		return

	invulneravel = true
	health -= 1
	print("Yume tomou dano:", health)
	
	# Efeito visual de dano
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


# --- FUNÇÃO PARA SER CHAMADA PELO PROJÉTIL ---
func hit_by_projectile():
	if esta_morta or invulneravel or can_dodge:
		# Se está em modo desvio, não toma dano (conseguiu desviar)
		if can_dodge:
			print("Yume desviou do projétil!")
			return
	take_damage()
