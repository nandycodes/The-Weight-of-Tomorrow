extends CanvasLayer

@onready var botao_comecar = $VBoxContainer/Start
@onready var botao_continuar = $VBoxContainer/Continuar
@onready var botao_sair = $VBoxContainer/Sair

func _ready():
	# Conecta os sinais
	botao_comecar.pressed.connect(_on_comecar_pressed)
	botao_continuar.pressed.connect(_on_continuar_pressed)
	botao_sair.pressed.connect(_on_sair_pressed)
	
	# Verifica se existe save para mostrar o botão Continuar
	atualizar_botao_continuar()

func atualizar_botao_continuar():
	if GameManager.save_existe():
		botao_continuar.visible = true
		botao_continuar.disabled = false
	else:
		botao_continuar.visible = false  # ou disabled = true se quiser mostrar cinza
		# botao_continuar.disabled = true  (descomente se preferir mostrar desabilitado)

func _on_comecar_pressed():
	GameManager.iniciar_novo_jogo()

func _on_continuar_pressed():
	GameManager.continuar_jogo()

func _on_sair_pressed():
	GameManager.sair_jogo()
