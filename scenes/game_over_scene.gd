extends CanvasLayer

@onready var botao_tentar_novamente = $VBoxContainer/Tentar
@onready var botao_desistir = $VBoxContainer/Desistir         

func _ready():
	# Garante que a tela funcione corretamente
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	# Conecta os botões
	if botao_tentar_novamente:
		botao_tentar_novamente.pressed.connect(_on_tentar_novamente_pressed)
		print("✅ Botão 'Tentar de novo' conectado")
	else:
		print("❌ Botão 'Tentar de novo' não encontrado!")
	
	if botao_desistir:
		botao_desistir.pressed.connect(_on_desistir_pressed)
		print("✅ Botão 'Desistir' conectado")
	else:
		print("❌ Botão 'Desistir' não encontrado!")

func _on_tentar_novamente_pressed():
	print("🔴 Game Over - Tentar de novo pressionado")
	GameManager.reiniciar_jogo()

func _on_desistir_pressed():
	print("🔴 Game Over - Desistir pressionado")
	GameManager.voltar_menu()
