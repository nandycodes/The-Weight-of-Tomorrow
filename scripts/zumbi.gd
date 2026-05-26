extends CharacterBody2D

# --- SINAL PERSONALIZADO PARA A ALAVANCA ---
signal morreu

const SPEED = 50
const GRAVITY = 900
const ATTACK_DISTANCE = 60 # Distância ideal para atacar sem travar na colisão do corpo

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

	# Se a Yume NÃO está na área de visão
	if player == null:
		velocity.x = 0
		if !attacking:
			anim.play("idle")
		move_and_slide()
		return

	# Se a Yume ESTÁ na área, calcula direção e distância horizontal
	var direction = player.global_position.x - global_position.x
	var distance = abs(direction)

	# Vira o sprite do zumbi para o lado certo
	anim.flip_h = direction < 0

	if !attacking:
		# Se estiver longe, persegue
		if distance > ATTACK_DISTANCE:
			velocity.x = sign(direction) * SPEED
			anim.play("walk")
		# Se chegou perto, para e ataca
		else:
			velocity.x = 0
			attack()

	move_and_slide()


# --- LÓGICA DE ATAQUE ---
func attack():
	if dead or attacking:
		return

	attacking = true
	anim.play("attack")

	# Criamos um timer seguro que ignora o pause do jogo (evita travar a tela)
	var timer = get_tree().create_timer(0.4, false, false, true)
	await timer.timeout

	# Verificação dupla de segurança antes de aplicar o dano
	if !dead and player != null and is_instance_valid(player):
		if player.has_method("take_damage") and !player.get("esta_morta"):
			player.take_damage()

	# Espera a animação terminar com uma alternativa se o jogo pausar a meio
	if anim.is_playing() and anim.animation == "attack":
		await anim.animation_finished
	else:
		await get_tree().create_timer(0.2, false, false, true).timeout

	attacking = false


# --- SINAIS DA AREA2D (CAMPO DE VISÃO) ---
func _on_area_2d_body_entered(body):
	if body.name == "Yume":
		player = body
		print("Zumbi avistou a Yume!")


func _on_area_2d_body_exited(body):
	if body.name == "Yume":
		player = null
		print("Yume escapou da visão do zumbi!")


# --- SISTEMA DE DANO E MORTE ---
func take_damage():
	if dead:
		return

	health -= 1
	print("Zumbi tomou dano! Vida restante:", health)

	if health <= 0:
		die()


func die():
	if dead:
		return

	dead = true
	velocity = Vector2.ZERO
	
	# --- AJUSTE EXCLUSIVO PARA A ANIMAÇÃO DE MORTE ---
	anim.offset.y = -22  # Empurra o sprite para CIMA apenas quando morre
	anim.offset.x = 12   # Empurra o sprite para o LADO apenas quando morre
	# -------------------------------------------------

	anim.play("die")
	
	# --- EMITE O SINAL PARA REVELAR A ALAVANCA ---
	emit_signal("morreu")
	
	await anim.animation_finished
	queue_free() # Remove o zumbi da cena após a animação terminar
