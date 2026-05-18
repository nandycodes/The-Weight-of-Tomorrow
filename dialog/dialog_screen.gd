extends Control
class_name DialogScreen

var _step: float = 0.05

var _id: int = 0
var data: Dictionary = {}

@export_category("Objects")
@export var _name: Label = null
@export var _dialog: RichTextLabel = null
@export var _faceset: TextureRect = null

func _ready() -> void:
	# Apenas para testes: se o seu 'data' estiver vindo vazio de outra cena (como do quarto),
	# você pode descomentar as linhas abaixo para testar o diálogo diretamente nesta cena.
	# data = {
	# 	0: {"title": "Yume", "dialog": "hhh", "faceset": "res://sprites/yume_face.png"}
	# }
	_initialize_dialog()

func _process(_delta: float) -> void:
	# Se apertar Enter/Espaço enquanto o texto está surgindo, acelera a velocidade
	if Input.is_action_pressed("ui_accept") and _dialog.visible_ratio < 1:
		_step = 0.01
		return
	
	# Caso contrário, mantém a velocidade normal
	_step = 0.05
	
	# Passar para a próxima fala do diálogo
	if Input.is_action_just_pressed("ui_accept") and _dialog.visible_ratio >= 1:
		_id += 1
		
		# Se as falas acabaram, fecha a caixa de diálogo
		if _id >= data.size():
			queue_free() # Remove a caixa da tela
		else:
			_initialize_dialog() # Carrega a próxima fala

func _initialize_dialog() -> void:
	# Verifica se o dicionário data tem informações antes de tentar carregar
	if data.is_empty():
		return
		
	_name.text = data[_id]["title"]
	_dialog.text = data[_id]["dialog"]
	_faceset.texture = load(data[_id]["faceset"])
	
	_dialog.visible_characters = 0
	
	# Efeito de digitar o texto letra por letra
	while _dialog.visible_ratio < 1:
		await get_tree().create_timer(_step).timeout
		_dialog.visible_characters += 1
