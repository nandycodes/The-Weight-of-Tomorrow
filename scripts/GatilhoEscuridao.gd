extends Area2D

@onready var escuridao_rect = $"../ColorRect"

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Yume":
		var material_shader = escuridao_rect.material
		if material_shader:
			var tween = create_tween()
			tween.tween_property(material_shader, "shader_parameter/intensidade", 0.8, 1.0)

func _on_body_exited(body: Node2D) -> void:
	if body.name == "Yume":
		var material_shader = escuridao_rect.material
		if material_shader:
			var tween = create_tween()
			tween.tween_property(material_shader, "shader_parameter/intensidade", 0.2, 1.0)
