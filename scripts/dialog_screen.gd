extends Control

# Cria o sinal que o seu quarto (room.gd) está esperando para iniciar a transição
signal dialogo_fechou

# Elementos visuais da caixinha
@onready var faceset: TextureRect = $Background/HContainer/Border/Faceset
@onready var name_label: Label = $Background/HContainer/VContainer/Name
@onready var dialog_label: Label = $Background/HContainer/VContainer/Dialog

var data: Dictionary = {}
var current_dialog_id: int = 0

func _ready() -> void:
	# Começa exibindo a primeira fala se os dados existirem
	if data.size() > 0:
		show_dialog()
	else:
		queue_free()

func _input(event: InputEvent) -> void:
	# Passa o diálogo ao clicar com o mouse ou apertar Espaço/Enter
	if event.is_action_pressed("ui_accept") or (event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT):
		current_dialog_id += 1
		
		# Se ainda tiver falas, mostra a próxima. Se não, fecha!
		if current_dialog_id < data.size():
			show_dialog()
		else:
			dialogo_fechou.emit() # Emite o sinal para o quarto escurecer!
			queue_free()

func show_dialog() -> void:
	# Atualiza os textos e a foto do personagem na tela
	var current_data = data[current_dialog_id]
	name_label.text = current_data["title"]
	dialog_label.text = current_data["dialog"]
	faceset.texture = load(current_data["faceset"])
