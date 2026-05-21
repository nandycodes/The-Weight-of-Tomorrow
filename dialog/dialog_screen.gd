extends Control

var data: Dictionary = {}
var current_dialog_id: int = 0

# Usamos caminhos genéricos para não dar erro se mudar o nome dos nós filhos
@onready var faceset = get_node_or_null("Background/Faceset")
@onready var name_label = get_node_or_null("Background/NameLabel")
@onready var dialog_label = get_node_or_null("Background/DialogLabel")

func _initialize_dialog() -> void:
	current_dialog_id = 0
	_update_dialog_ui()

func _update_dialog_ui() -> void:
	if data.has(current_dialog_id):
		var current_data = data[current_dialog_id]
		
		# Só atualiza se os nós existirem de verdade na cena
		if dialog_label: dialog_label.text = current_data["dialog"]
		if name_label: name_label.text = current_data["title"]
		if faceset and ResourceLoader.exists(current_data["faceset"]):
			faceset.texture = load(current_data["faceset"])
