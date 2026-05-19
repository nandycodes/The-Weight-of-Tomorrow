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
		
		# Se as falas acabaram
		if _id >= data.size():

			# Remove a caixa de diálogo
			queue_free()

			# Vai para a floresta
			get_tree().change_scene_to_file("res://scenes/florest.tscn")

		else:
			_initialize_dialog()

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

		# Se o node foi removido da cena, para o loop
		if !is_inside_tree():
			return

		await get_tree().create_timer(_step).timeout

		# Verifica novamente após o await
		if !is_inside_tree():
			return

		_dialog.visible_characters += 1
