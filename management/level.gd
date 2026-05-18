extends Node2D
class_name Level

# Verifique se o caminho abaixo está correto no seu computador!
const _DIALOG_SCREEN: PackedScene = preload("res://dialog/dialog_screen.tscn")

var _dialog_data: Dictionary = {
	0: {
		"faceset": "res://dialog/assets/yumeFace.png",
		"dialog": "Finalmente fechei aqueles livros da faculdade... Minha cabeça estava prestes a explodir de tanto estudar.",
		"title": "Yume"
	},
	1: {
		"faceset": "res://dialog/assets/yumeFace.png",
		"dialog": "Coloquei esse filme de zumbi para ver se desligo um pouco, mas nem consigo prestar atenção na história.",
		"title": "Yume"
	},
	2: {
		"faceset": "res://dialog/assets/yumeFace.png",
		"dialog": "O cansaço é tão grande que as imagens parecem só passar pela minha tela... e os pensamentos continuam longe.",
		"title": "Yume"
	},
	3: {
		"faceset": "res://dialog/assets/yumeFace.png",
		"dialog": "Só queria conseguir descansar de verdade, sem que a pressão do amanhã ficasse martelando na minha mente.",
		"title": "Yume"
	}
}
