extends Button

var mouse_sobre = false

func _ready():
	# remove estilo padrão
	add_theme_stylebox_override("normal", StyleBoxEmpty.new())
	add_theme_stylebox_override("hover", StyleBoxEmpty.new())
	add_theme_stylebox_override("pressed", StyleBoxEmpty.new())
	
	# estilo do texto
	add_theme_color_override("font_color", Color(1, 1, 1, 0.6))
	add_theme_color_override("font_hover_color", Color(1, 1, 1, 0.9))
	add_theme_color_override("font_pressed_color", Color(1, 1, 1, 0.8))
	
	# TAMANHO MAIOR (era 140, 32)
	custom_minimum_size = Vector2(180, 45)
	
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	button_down.connect(queue_redraw)
	button_up.connect(queue_redraw)

func _on_mouse_entered():
	mouse_sobre = true
	queue_redraw()

func _on_mouse_exited():
	mouse_sobre = false
	queue_redraw()

func _draw():
	var rect = Rect2(Vector2(2, 2), size - Vector2(4, 4))
	var raio = 3
	
	var cor_borda
	var cor_fundo
	var alpha_fundo
	
	if mouse_sobre:
		cor_borda = Color(0.423, 0.131, 0.269, 1.0)
		alpha_fundo = 0.5
	else:
		cor_borda = Color(0.83, 0.65, 0.72, 0.4)
		alpha_fundo = 0.15
	
	cor_fundo = Color(0.05, 0.03, 0.05, alpha_fundo)
	
	# EFEITO EMBACADO (GLOW) - várias camadas com transparência
	if mouse_sobre:
		# camadas de glow (quanto mais longe, mais fraco e embaçado)
		draw_rect(rect.grow(8), Color(1, 0.5, 0.9, 0.03), false, 2.0)
		draw_rect(rect.grow(6), Color(1, 0.5, 0.9, 0.06), false, 2.0)
		draw_rect(rect.grow(4), Color(1, 0.5, 0.9, 0.10), false, 1.5)
		draw_rect(rect.grow(3), Color(1, 0.5, 0.9, 0.15), false, 1.5)
		draw_rect(rect.grow(2), Color(0.586, 0.218, 0.389, 1.0), false, 1.0)
		draw_rect(rect.grow(1), Color(0.386, 0.125, 0.247, 1.0), false, 1.0)
	
	# fundo com cantos levemente arredondados
	var rect_fundo = Rect2(rect.position + Vector2(raio, raio), rect.size - Vector2(raio * 2, raio * 2))
	draw_rect(rect_fundo, cor_fundo, true)
	
	# cantos do fundo
	draw_circle(Vector2(rect.position.x + raio, rect.position.y + raio), raio, cor_fundo)
	draw_circle(Vector2(rect.end.x - raio, rect.position.y + raio), raio, cor_fundo)
	draw_circle(Vector2(rect.position.x + raio, rect.end.y - raio), raio, cor_fundo)
	draw_circle(Vector2(rect.end.x - raio, rect.end.y - raio), raio, cor_fundo)
	
	# borda principal (fina)
	draw_rect(rect_fundo, cor_borda, false, 0.8)
	
	# cantos da borda
	draw_arc(Vector2(rect.position.x + raio, rect.position.y + raio), raio, PI, 1.5 * PI, 4, cor_borda, 0.8)
	draw_arc(Vector2(rect.end.x - raio, rect.position.y + raio), raio, 1.5 * PI, 2 * PI, 4, cor_borda, 0.8)
	draw_arc(Vector2(rect.position.x + raio, rect.end.y - raio), raio, 0.5 * PI, PI, 4, cor_borda, 0.8)
	draw_arc(Vector2(rect.end.x - raio, rect.end.y - raio), raio, 0, 0.5 * PI, 4, cor_borda, 0.8)
	
	# detalhes nos cantos (hover)
	if mouse_sobre:
		var tamanho = 3
		draw_line(Vector2(rect.position.x + 2, rect.position.y + 1), 
				  Vector2(rect.position.x + tamanho, rect.position.y + 1), cor_borda, 0.6)
		draw_line(Vector2(rect.position.x + 1, rect.position.y + 2), 
				  Vector2(rect.position.x + 1, rect.position.y + tamanho), cor_borda, 0.6)
		
		draw_line(Vector2(rect.end.x - 2, rect.position.y + 1), 
				  Vector2(rect.end.x - tamanho, rect.position.y + 1), cor_borda, 0.6)
		draw_line(Vector2(rect.end.x - 1, rect.position.y + 2), 
				  Vector2(rect.end.x - 1, rect.position.y + tamanho), cor_borda, 0.6)
		
		draw_line(Vector2(rect.position.x + 2, rect.end.y - 1), 
				  Vector2(rect.position.x + tamanho, rect.end.y - 1), cor_borda, 0.6)
		draw_line(Vector2(rect.position.x + 1, rect.end.y - 2), 
				  Vector2(rect.position.x + 1, rect.end.y - tamanho), cor_borda, 0.6)
		
		draw_line(Vector2(rect.end.x - 2, rect.end.y - 1), 
				  Vector2(rect.end.x - tamanho, rect.end.y - 1), cor_borda, 0.6)
		draw_line(Vector2(rect.end.x - 1, rect.end.y - 2), 
				  Vector2(rect.end.x - 1, rect.end.y - tamanho), cor_borda, 0.6)
