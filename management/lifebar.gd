extends TextureProgressBar

@onready var player = $"../../../../Yume"


@onready var label_books = %Labelbooks

@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	max_value = 5
	value = player.health
	
	
	if label_books and player:
		label_books.text = "x" + str(player.livros)
