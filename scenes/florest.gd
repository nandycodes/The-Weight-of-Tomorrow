extends Node2D

# Criamos a variável vazia primeiro
var caixa_dialogo: Control

func _ready() -> void:
	# Força o script a esperar um frame para garantir que o CanvasLayer carregou tudo
	await get_tree().process_frame
	
	# Agora que está tudo carregado, pegamos a referência sem erro
	caixa_dialogo = $CanvasLayer/DialogScreen as Control
	
	# 🔥 VERIFICA SE JÁ VIU O DIÁLOGO DA FLORESTA
	if GameManager.dialogo_visto("Florest"):
		print("✅ Diálogo da Floresta já foi visto, pulando...")
		_pular_dialogo()
	else:
		print("🎬 Mostrando diálogo da Floresta...")
		# Só dispara o diálogo se o nó realmente foi encontrado
		if caixa_dialogo:
			configurar_dialogo_floresta()
		else:
			print("Erro: Não encontrei o nó DialogScreen dentro de CanvasLayer!")

# 🔥 FUNÇÃO PARA PULAR O DIÁLOGO
func _pular_dialogo():
	if caixa_dialogo:
		caixa_dialogo.visible = false
	_ativar_jogo()

# 🔥 FUNÇÃO PARA ATIVAR O JOGO (player, portões, etc.)
func _ativar_jogo():
	print("🎮 Floresta ativada!")
	# Coloque aqui o código para ativar o player, portões, etc.

# ============ PAUSA ============
func _input(event):
	if event.is_action_pressed("ui_cancel"):  # Tecla ESC
		GameManager.pausar()
# ================================

func configurar_dialogo_floresta() -> void:
	var novas_falas: Dictionary = {
		"0": {
			"title": "Yume",
			"dialog": "... Ahn?",
			"faceset": "res://dialog/assets/yumeFace.png"
		},
		"1": {
			"title": "Yume",
			"dialog": "Onde eu estou?...",
			"faceset": "res://dialog/assets/yumeFace.png"
		},
		"2": {
			"title": "Yume",
			"dialog": "Que lugar escuro é esse?...",
			"faceset": "res://dialog/assets/yumeFace.png"
		},
		"3": {
			"title": "Yume",
			"dialog": "Eu estava no meu quarto ainda há pouco.",
			"faceset": "res://dialog/assets/yumeFace.png"
		},
		"4": {
			"title": "Yume",
			"dialog": "Estava terminando de estudar na mesa...",
			"faceset": "res://dialog/assets/yumeFace.png"
		},
		"5": {
			"title": "Yume",
			"dialog": "Que frio estranho... Esse vento parece real demais.",
			"faceset": "res://dialog/assets/yumeFace.png"
		},
		"6": {
			"title": "Yume",
			"dialog": "Será que eu peguei no sono e estou sonhando?",
			"faceset": "res://dialog/assets/yumeFace.png"
		},
		"7": {
			"title": "Yume",
			"dialog": "Isso está me dando um baita pressentimento ruim...",
			"faceset": "res://dialog/assets/yumeFace.png"
		},
		"8": {
			"title": "Yume",
			"dialog": "Preciso achar uma saída daqui. Rápido.",
			"faceset": "res://dialog/assets/yumeFace.png"
		}
	}
	
	# Alimenta os dados com segurança
	caixa_dialogo.data = novas_falas
	caixa_dialogo.current_dialog_id = 0
	
	# 🔥 CONECTA O FIM DO DIÁLOGO (se o sistema tiver sinal)
	if caixa_dialogo.has_signal("dialogo_terminou"):
		caixa_dialogo.dialogo_terminou.connect(_dialogo_terminou)
	
	caixa_dialogo.show_dialog()

# 🔥 FUNÇÃO CHAMADA QUANDO O DIÁLOGO TERMINA
func _dialogo_terminou():
	print("✅ Diálogo da Floresta concluído!")
	GameManager.completar_dialogo("Florest")
	_ativar_jogo()
