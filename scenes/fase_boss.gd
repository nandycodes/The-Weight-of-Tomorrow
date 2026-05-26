extends Node2D


# ============ PAUSA ============
func _input(event):
	if event.is_action_pressed("ui_cancel"):  # Tecla ESC
		GameManager.pausar()
# ================================


func _on_btn_2_pressed() -> void:
	pass # Replace with function body.
