extends CanvasLayer

@onready var botao_tentar_novamente = $VBoxContainer/Voltar
@onready var botao_desistir = $VBoxContainer/Desistir_pause

func _ready():
	# 🔥 LINHA CRUCIAL: Garante que os efeitos/brilhos/animações continuem rodando
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	# Verifica se os botões existem antes de conectar
	if botao_tentar_novamente:
		botao_tentar_novamente.pressed.connect(_on_tentar_novamente_pressed)
		print("✅ Botão 'Voltar' conectado")
	else:
		print("Erro: Botão 'Tentar Novamente' não encontrado!")
	
	if botao_desistir:
		botao_desistir.pressed.connect(_on_desistir_pressed)
		print("✅ Botão 'Desistir_pause' conectado")
	else:
		print("Erro: Botão 'Desistir' não encontrado!")

func _on_tentar_novamente_pressed():
	print("Tentar de novo pressionado")
	GameManager.reiniciar_fase_atual()

func _on_desistir_pressed():
	print("Desistir pressionado")
	GameManager.desistir()
