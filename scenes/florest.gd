extends Node2D

# Criamos a variável vazia primeiro
var caixa_dialogo: Control

func _ready() -> void:
	# Força o script a esperar um frame para garantir que o CanvasLayer carregou tudo
	await get_tree().process_frame
	
	# Agora que está tudo carregado, pegamos a referência sem erro
	caixa_dialogo = $CanvasLayer/DialogScreen as Control
	
	# Só dispara o diálogo se o nó realmente foi encontrado
	if caixa_dialogo:
		configurar_dialogo_floresta()
	else:
		print("Erro: Não encontrei o nó DialogScreen dentro de CanvasLayer!")

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
	caixa_dialogo.show_dialog()
