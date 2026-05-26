extends Node2D

var brilhos = []

func _ready():
	for i in range(60):  # quantidade
		# escolhe cor aleatória: 0 = branco, 1 = dourado
		var cor_tipo = randi() % 2
		brilhos.append({
			"pos": Vector2(randf() * 1024, randf() * 600),
			"vel": Vector2(randf_range(-8, 8), randf_range(-5, 5)),
			"fase": randf() * TAU,
			"velocidade_pulso": randf_range(2.0, 4.0),
			"cor_tipo": cor_tipo,
		})

func _process(delta):
	for b in brilhos:
		b.pos += b.vel * delta
		b.fase += delta * b.velocidade_pulso
		
		if b.pos.x > 1024: b.pos.x = 0
		if b.pos.x < 0: b.pos.x = 1024
		if b.pos.y > 600: b.pos.y = 0
		if b.pos.y < 0: b.pos.y = 600
	
	queue_redraw()

func _draw():
	for b in brilhos:
		var intensidade = (sin(b.fase) + 1.0) / 2.0
		var alpha = 0.15 + intensidade * 0.25
		
		# escolhe a cor baseada no tipo
		var cor
		if b.cor_tipo == 0:
			cor = Color(1, 1, 1, alpha)      # branco
		else:
			cor = Color(0.659, 0.277, 0.379, 1.0)# dourado
		
		draw_circle(b.pos, randf_range(0.5, 1.2), cor)
