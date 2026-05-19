extends Node2D

# Carrega a cena da caixinha de diálogo na memória
const DIALOG_SCREEN = preload("res://dialog/dialog_screen.tscn")

var dialogue_data: Dictionary = {
	0: {
		"faceset": "res://dialog/assets/yumeFace.png",
		"dialog": "Finalmente fechei os livros da faculdade. Minha cabeça está explodindo.",
		"title": "Yume"
	},
	1: {
		"faceset": "res://dialog/assets/yumeFace.png",
		"dialog": "Coloquei esse filme de zumbi para relaxar, mas nem consigo prestar atenção.",
		"title": "Yume"
	},
	2: {
		"faceset": "res://dialog/assets/yumeFace.png",
		"dialog": "As imagens só passam pela tela... Meus pensamentos continuam longe.",
		"title": "Yume"
	},
	3: {
		"faceset": "res://dialog/assets/yumeFace.png",
		"dialog": "Só queria descansar sem sentir o peso do amanhã martelando na mente.",
		"title": "Yume"
	}
}

func _ready() -> void:

	# Espera um frame para carregar os elementos da cena
	await get_tree().process_frame
	
	if has_node("HUD"):

		# Cria a caixa de diálogo
		var new_dialog = DIALOG_SCREEN.instantiate()
		new_dialog.data = dialogue_data
		$HUD.add_child(new_dialog)

	else:
		print("ERRO: O nó chamado HUD não foi encontrado na cena do quarto!")
