extends Node2D

var folhas = []

func _ready():
	for i in range(25):
		folhas.append({
			"pos": Vector2(randf() * 640, randf() * 360),
			"vel": Vector2(randf_range(-12, 12), randf_range(15, 45)),
			"rotacao": randf_range(0, TAU),
			"vel_rotacao": randf_range(-1.5, 1.5),
			"largura": randf_range(6, 12),
			"altura": randf_range(10, 18),
			"opacidade": randf_range(0.2, 0.5)
		})

func _process(delta):
	for f in folhas:
		f.pos += f.vel * delta
		f.rotacao += f.vel_rotacao * delta
		
		if f.pos.y > 360:
			f.pos.y = -20
			f.pos.x = randf() * 640
		
		if f.pos.x > 640:
			f.pos.x = -20
		if f.pos.x < -20:
			f.pos.x = 640
	
	queue_redraw()

func _draw():
	for f in folhas:
		draw_folha_rasgada(f.pos, f.largura, f.altura, f.rotacao, Color(0.04, 0.02, 0.06, f.opacidade))

func draw_folha_rasgada(pos, largura, altura, rotacao, cor):
	var transform = Transform2D(rotacao, pos)
	
	# polígono em ordem HORÁRIA (garantido sem cruzamento)
	var pontos = PackedVector2Array()
	
	var rasgo_superior = randf_range(-2, 2)
	var rasgo_direito = randf_range(-2, 2)
	var rasgo_inferior = randf_range(-2, 2)
	var rasgo_esquerdo = randf_range(-2, 2)
	
	pontos.append(transform * Vector2(-largura/2 + rasgo_esquerdo, -altura/2 + rasgo_superior))
	pontos.append(transform * Vector2(largura/2 + rasgo_direito, -altura/2 + randf_range(-1, 1)))
	pontos.append(transform * Vector2(largura/2 + randf_range(-1, 1), altura/2 + rasgo_direito))
	pontos.append(transform * Vector2(-largura/2 + rasgo_esquerdo, altura/2 + rasgo_inferior))
	
	# desenha o polígono
	draw_polygon(pontos, PackedColorArray([cor]))
	
	# borda (sem usar + com array)
	var pontos_borda = PackedVector2Array(pontos)
	pontos_borda.append(pontos[0])
	draw_polyline(pontos_borda, Color(0.02, 0.01, 0.03, cor.a * 0.6), 0.6)
	
	# detalhe: "rasgo" interno
	var meio_x = randf_range(-largura/4, largura/4)
	var meio_y = randf_range(-altura/4, altura/4)
	var ponto_meio = transform * Vector2(meio_x, meio_y)
	var ponto_rasgo = transform * Vector2(meio_x + randf_range(-3, 3), meio_y + randf_range(-2, 2))
	draw_line(ponto_meio, ponto_rasgo, Color(0.01, 0.005, 0.02, cor.a * 0.5), 0.5)
