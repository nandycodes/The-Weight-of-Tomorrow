extends Node2D

# ============ PAUSA ============
func _input(event):
	if event.is_action_pressed("ui_cancel"):  # Tecla ESC
		GameManager.pausar()
# ================================
