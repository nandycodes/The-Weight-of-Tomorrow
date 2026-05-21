extends Control

# Cria o sinal que o seu quarto (room.gd) está esperando para iniciar a transição
signal dialogo_fechou

# Elementos visuais da caixinha
@onready var faceset: TextureRect = $Background/HContainer/Border/Faceset
@onready var name_label: Label = $Background/HContainer/VContainer/Name
@onready var dialog_label: RichTextLabel = $Background/HContainer/VContainer/Dialog

# Começa vazio para podermos mudar dinamicamente na floresta!
var data: Dictionary = {}
var current_dialog_id: int = 0
var tween: Tween # Variável para controlar a animação do texto

func _ready() -> void:
	# SE NINGUÉM PASSOU FALA (ex: no Quarto), carrega o roteiro padrão do começo do jogo
	if data.is_empty():
		carregar_roteiro_quarto()
		
	# Começa exibindo a primeira fala se os dados existirem
	if data.size() > 0:
		show_dialog()
	else:
		queue_free()

func carregar_roteiro_quarto() -> void:
	data = {
		"0": {"title": "Yume", "dialog": "Pronto...", "faceset": "res://dialog/assets/yumeFace.png"},
		"1": {"title": "Yume", "dialog": "Finalmente terminei de estudar tudo.", "faceset": "res://dialog/assets/yumeFace.png"},
		"2": {"title": "Yume", "dialog": "Acho que revisei essa matéria umas mil vezes.", "faceset": "res://dialog/assets/yumeFace.png"},
		"3": {"title": "Yume", "dialog": "Minha cabeça está até fervendo...", "faceset": "res://dialog/assets/yumeFace.png"},
		"4": {"title": "Yume", "dialog": "Coloquei esse filme de zumbi para relaxar.", "faceset": "res://dialog/assets/yumeFace.png"},
		"5": {"title": "Yume", "dialog": "Tentar distrair a mente antes de deitar.", "faceset": "res://dialog/assets/yumeFace.png"},
		"6": {"title": "Yume", "dialog": "Mas está difícil focar na tela...", "faceset": "res://dialog/assets/yumeFace.png"},
		"7": {"title": "Yume", "dialog": "Meus olhos estão pesando demais.", "faceset": "res://dialog/assets/yumeFace.png"},
		"8": {"title": "Yume", "dialog": "Caramba, eu estou completamente exausta.", "faceset": "res://dialog/assets/yumeFace.png"},
		"9": {"title": "Yume", "dialog": "Até tomei uma xícara de café...", "faceset": "res://dialog/assets/yumeFace.png"},
		"10": {"title": "Yume", "dialog": "...mas acho que não adiantou nada.", "faceset": "res://dialog/assets/yumeFace.png"},
		"11": {"title": "Yume", "dialog": "Não posso dormir aqui na mesa.", "faceset": "res://dialog/assets/yumeFace.png"},
		"12": {"title": "Yume", "dialog": "Preciso levantar e ir para a cama...", "faceset": "res://dialog/assets/yumeFace.png"},
		"13": {"title": "Yume", "dialog": "Só mais cinco minutinhos...", "faceset": "res://dialog/assets/yumeFace.png"},
		"14": {"title": "Yume", "dialog": "Vou só fechar os olhos por um instan...", "faceset": "res://dialog/assets/yumeFace.png"}
	}

func _input(event: InputEvent) -> void:
	var teclado_pressionado = event.is_action_pressed("ui_accept", false)
	var mouse_pressionado = event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.pressed
	
	if teclado_pressionado or mouse_pressionado:
		get_viewport().set_input_as_handled()
		
		# SE O TEXTO AINDA ESTIVER APARECENDO: Completa o texto instantaneamente ao clicar
		if tween and tween.is_running():
			tween.kill()
			dialog_label.visible_ratio = 1.0
			return # Para a execução aqui para não pular de fala direto
		
		current_dialog_id += 1
		
		# Se ainda tiver falas, mostra a próxima. Se não, fecha!
		if current_dialog_id < data.size():
			show_dialog()
		else:
			dialogo_fechou.emit() # Emite o sinal para o quarto saber que ela dormiu!
			queue_free()

func show_dialog() -> void:
	var current_key = str(current_dialog_id)
	
	if data.has(current_key):
		var current_data = data[current_key]
		
		name_label.text = current_data["title"]
		dialog_label.text = current_data["dialog"]
		
		# EFEITO MÁQUINA DE ESCREVER COM RITMO DE SONO:
		dialog_label.visible_ratio = 0.0
		
		if tween:
			tween.kill()
			
		tween = create_tween()
		
		# Mantém a digitação mais lenta (0.06) expressando o cansaço
		var duracao_do_texto = current_data["dialog"].length() * 0.06
		
		tween.tween_property(dialog_label, "visible_ratio", 1.0, duracao_do_texto)
		
		# Só tenta carregar o faceset se o caminho não estiver vazio e o arquivo existir
		if current_data["faceset"] != "" and ResourceLoader.exists(current_data["faceset"]):
			faceset.texture = load(current_data["faceset"])
		else:
			faceset.texture = null 
	else:
		queue_free()
