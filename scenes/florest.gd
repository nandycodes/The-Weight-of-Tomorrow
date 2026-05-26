extends Node2D

var caixa_dialogo: Control

func _ready() -> void:
	await get_tree().process_frame
	caixa_dialogo = $CanvasLayer/DialogScreen as Control
	
	if GameManager.dialogo_visto("Florest"):
		_pular_dialogo()
	else:
		if caixa_dialogo:
			configurar_dialogo_floresta()

func _pular_dialogo():
	if caixa_dialogo:
		caixa_dialogo.visible = false
	_ativar_jogo()

func _ativar_jogo():
	print("🎮 Floresta ativada!")

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		GameManager.pausar()

func configurar_dialogo_floresta() -> void:
	# ... (seus dados de fala)
	caixa_dialogo.show_dialog()
	if caixa_dialogo.has_signal("dialogo_terminou"):
		caixa_dialogo.dialogo_terminou.connect(_dialogo_terminou)

func _dialogo_terminou():
	GameManager.completar_dialogo("Florest")
	_ativar_jogo()

# ==========================================================
# TRANSIÇÃO DE FASE CORRIGIDA
# ==========================================================
func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.name == "Yume":
		print("🚪 Transição iniciada!")
		
		# 1. Trava o movimento da Yume
		body.set_physics_process(false)
		body.set_process(false)
		
		# 2. Desativa a KillZone com segurança (set_deferred)
		if has_node("KillZone"):
			$KillZone.set_deferred("monitoring", false)
			$KillZone.set_deferred("monitorable", false)
			
		# 3. Roda a animação
		if has_node("Transicao/AnimationPlayer"):
			$Transicao/AnimationPlayer.play("esconder")
			await $Transicao/AnimationPlayer.animation_finished
		
		# 4. Muda de cena com o caminho correto da pasta 'scenes'
		get_tree().change_scene_to_file("res://scenes/fase_boss.tscn")
