extends CanvasLayer

@onready var faceset = $Background/HContainer/Border/Faceset
@onready var name_label = $Background/HContainer/VContainer/Name
@onready var dialog_label = $Background/HContainer/VContainer/Dialog
@onready var btn1 = $VBoxContainer/Btn1
@onready var btn2 = $VBoxContainer/Btn2
@onready var btn3 = $VBoxContainer/Btn3
@onready var yume = $"../Yume"
@onready var billet = $"../Billet"

# Variáveis do jogo
var current_question_index = 0
var hits = 0
var errors = 0
var can_answer = false
var dialog_active = true
var waiting_for_answer = false
var is_game_over = false

# Carrega a cena do projétil
var projectile_scene = preload("res://entities/bills_projectile.tscn")

# Array com as 10 perguntas
var questions = [
	{
		"text": "O que significa HTML?",
		"options": ["Hyper Text Markup Language", "High Tech Modern Language", "Hyper Transfer Main Link"],
		"correct": 0,
		"right_comment": "Ok. Você sabe o mínimo. Mas o mínimo não paga boleto.",
		"wrong_comment": "Errar o básico... esse é o peso de não estudar. Chuva de boletos pra você."
	},
	{
		"text": "Qual a diferença entre == e ===?",
		"options": ["Nenhuma, são iguais", "== compara valor, === compara valor e tipo", "== compara tipo, === compara valor"],
		"correct": 1,
		"right_comment": "Comparação de tipo e valor. Talvez você tenha futuro.",
		"wrong_comment": "Erro besta. É assim que você lida com a pressão?"
	},
	{
		"text": "O que é Git?",
		"options": ["Um tipo de café", "Um sistema de controle de versão", "Uma linguagem de programação"],
		"correct": 1,
		"right_comment": "Versionar seus erros... pelo menos isso.",
		"wrong_comment": "Sem Git você perde tudo. Como perdeu essa resposta."
	},
	{
		"text": "O que é uma API?",
		"options": ["Um programa de edição de imagens", "Um tipo de vírus de computador", "Interface de programação de aplicações"],
		"correct": 2,
		"right_comment": "Integração... você pelo menos conversa com os outros sistemas.",
		"wrong_comment": "Sem API seu mundo é isolado. Que nem você vai ser se continuar errando."
	},
	{
		"text": "O que é SQL Injection?",
		"options": ["Uma injeção de código SQL maliciosa", "Um tipo de banco de dados", "Um comando para backup"],
		"correct": 0,
		"right_comment": "Segurança... você pensa no amanhã. Bom.",
		"wrong_comment": "Vulnerável. Igual seu emocional nessa reta final."
	},
	{
		"text": "Diferença entre var, let e const?",
		"options": ["Nenhuma, são todas iguais", "São formas de declarar variáveis com diferentes escopos", "Apenas var funciona em JavaScript"],
		"correct": 1,
		"right_comment": "Escopo definido. Você pelo menos organiza sua bagunça.",
		"wrong_comment": "Variável bagunçada. Que nem sua cabeça agora."
	},
	{
		"text": "O que é um algoritmo?",
		"options": ["Um tipo de vírus", "Uma sequência de passos para resolver um problema", "Um software de edição"],
		"correct": 1,
		"right_comment": "Passo a passo... talvez você chegue lá. Talvez.",
		"wrong_comment": "Sem método você não chega a lugar nenhum. Nem no amanhã."
	},
	{
		"text": "O que é recursão?",
		"options": ["Uma função que chama a si mesma", "Um tipo de loop infinito", "Um erro de compilação"],
		"correct": 0,
		"right_comment": "Função que chama a si mesma... igual sua ansiedade. Mas pelo menos você entende.",
		"wrong_comment": "Não entende recursão? Então não entende loops infinitos de fracasso também?"
	},
	{
		"text": "Pra que serve um banco de dados relacional?",
		"options": ["Armazenar arquivos de imagem", "Organizar dados em tabelas relacionadas", "Criar animações"],
		"correct": 1,
		"right_comment": "Organizar dados... você é menos bagunçada do que eu pensei.",
		"wrong_comment": "Dados soltos. Que nem sua vida acadêmica."
	},
	{
		"text": "O que significa CSS?",
		"options": ["Computer Style System", "Cascading Style Sheets", "Creative Style Software"],
		"correct": 1,
		"right_comment": "Estilo. Você tem estilo? Talvez. Mas estilo sem conteúdo não passa na porta da universidade.",
		"wrong_comment": "Sem estilo você é só mais um. E mais um não forma."
	}
]

func _ready():
	# 1. ANTIBLOQUEIO DE INTERFACE: Impede que os painéis traseiros roubem o clique do mouse
	$Background.mouse_filter = Control.MOUSE_FILTER_IGNORE
	$Background/HContainer.mouse_filter = Control.MOUSE_FILTER_IGNORE
	
	# 2. CONEXÃO SEGURA DOS SINAIS: Vincula as funções de clique direto no nascimento do script
	if not btn1.pressed.is_connected(_on_btn1_pressed):
		btn1.pressed.connect(_on_btn1_pressed)
	if not btn2.pressed.is_connected(_on_btn2_pressed):
		btn2.pressed.connect(_on_btn2_pressed)
	if not btn3.pressed.is_connected(_on_btn3_pressed):
		btn3.pressed.connect(_on_btn3_pressed)
		
	# 3. Esconde os botões para a introdução rodar limpa
	set_buttons_enabled(false)
	start_intro_dialogue()

func set_buttons_enabled(enabled):
	if not is_instance_valid(btn1):
		return
	btn1.disabled = not enabled
	btn1.visible = enabled
	btn2.disabled = not enabled
	btn2.visible = enabled
	btn3.disabled = not enabled
	btn3.visible = enabled

func start_intro_dialogue():
	dialog_active = true
	# Diálogos iniciais cronometrados (botões continuam invisíveis aqui)
	await show_dialogue_timed("Billet", "Você sente o peso, não sente? O peso de tudo que ainda precisa fazer. O peso de não poder falhar.", "res://sprites/characters/Boleto/billet_face.jpg")
	await show_dialogue_timed("Yume", "Eu carrego isso todo dia. Não é de hoje.", "res://dialog/assets/yumeFace.png")
	await show_dialogue_timed("Billet", "Você acha que aguentar o peso é suficiente? Não é. Saber carregar... isso é o que separa os que formam dos que desistem.", "res://sprites/characters/Boleto/billet_face.jpg")
	await show_dialogue_timed("Yume", "E você acha que eu vou desistir agora?", "res://dialog/assets/yumeFace.png")
	await show_dialogue_timed("Billet", "Não acho. Eu vou garantir. Cada erro seu... o céu vai cair. Esse é o peso do amanhã que você não conseguiu suportar.", "res://sprites/characters/Boleto/billet_face.jpg")
	await show_dialogue_timed("Yume", "Então vamos. Me mostre o que eu não sei.", "res://dialog/assets/yumeFace.png")
	
	dialog_active = false
	ask_next_question()

# Função auxiliar: Apenas atualiza o conteúdo visual imediatamente
func update_dialogue_ui(char_name, text, face_path):
	name_label.text = char_name
	dialog_label.text = text
	if ResourceLoader.exists(face_path):
		faceset.texture = load(face_path)
	else:
		print("ERRO: Imagem não encontrada em: ", face_path)

# Função para diálogos com tempo de espera (História e Comentários)
func show_dialogue_timed(char_name, text, face_path):
	if is_game_over:
		return
	update_dialogue_ui(char_name, text, face_path)
	await get_tree().create_timer(3.0).timeout

func ask_next_question():
	if is_game_over:
		return
		
	if hits >= 5:
		victory()
		return
	
	if current_question_index >= len(questions):
		if hits < 5:
			game_over()
		return
	
	# Reseta estados antes de liberar as respostas
	set_buttons_enabled(false)
	can_answer = false
	waiting_for_answer = false
	
	var q = questions[current_question_index]
	
	# 1. Altera o texto da caixa de diálogo da pergunta SEM travar o script por 3 segundos
	dialog_active = true
	update_dialogue_ui("Billet", q.text, "res://sprites/characters/Boleto/billet_face.jpg")
	dialog_active = false
	
	# 2. Configura os textos das alternativas
	btn1.text = q.options[0]
	btn2.text = q.options[1]
	btn3.text = q.options[2]
	
	# 3. Ativa e torna os botões visíveis de imediato junto com a pergunta
	set_buttons_enabled(true)
	can_answer = true
	waiting_for_answer = true

func _on_btn1_pressed():
	if can_answer and waiting_for_answer and not is_game_over:
		check_answer(0)

func _on_btn2_pressed():
	if can_answer and waiting_for_answer and not is_game_over:
		check_answer(1)

func _on_btn3_pressed():
	if can_answer and waiting_for_answer and not is_game_over:
		check_answer(2)

func check_answer(selected_index):
	if not can_answer or not waiting_for_answer or is_game_over:
		return
	
	# Tranca a entrada de dados para evitar cliques duplos/fantasmas
	can_answer = false
	waiting_for_answer = false
	set_buttons_enabled(false)
	
	var q = questions[current_question_index]
	var is_correct = (selected_index == q.correct)
	
	if is_correct:
		hits += 1
		dialog_active = true
		# Exibe o feedback de acerto por 3 segundos com os botões ocultos
		await show_dialogue_timed("Billet", q.right_comment, "res://sprites/characters/Boleto/billet_face.jpg")
		dialog_active = false
		if is_instance_valid(billet):
			billet.take_damage()
	else:
		errors += 1
		dialog_active = true
		# Exibe o feedback de erro por 3 segundos com os botões ocultos
		await show_dialogue_timed("Billet", q.wrong_comment, "res://sprites/characters/Boleto/billet_face.jpg")
		dialog_active = false
		
		spawn_projectiles()
		
		if is_instance_valid(yume) and yume.has_method("start_dodge_mode"):
			yume.start_dodge_mode()
	
	current_question_index += 1
	await get_tree().create_timer(1.0).timeout
	
	if errors >= 10 and not is_game_over:
		game_over()
	elif not is_game_over:
		ask_next_question()

func spawn_projectiles():
	print("=== CORTINA IMPENETRÁVEL ===")
	if is_game_over or projectile_scene == null:
		return
	
	var main_scene = get_tree().current_scene
	if main_scene == null:
		return
	
	var screen_width = get_viewport().size.x
	var espacamento = 25 
	var quantidade_por_linha = int(screen_width / espacamento) + 1
	
	for linha in range(5):
		for i in range(quantidade_por_linha):
			var projectile = projectile_scene.instantiate()
			main_scene.add_child(projectile)
			var pos_x = i * espacamento
			var pos_y = -50 + (linha * 80)
			projectile.position = Vector2(pos_x, pos_y)
		await get_tree().create_timer(0.05).timeout
	
	for linha in range(3):
		for i in range(quantidade_por_linha):
			var projectile = projectile_scene.instantiate()
			main_scene.add_child(projectile)
			var pos_x = i * espacamento
			var pos_y = 200 + (linha * 60) 
			projectile.position = Vector2(pos_x, pos_y)
		await get_tree().create_timer(0.03).timeout
		
func victory():
	if is_game_over:
		return
	is_game_over = true
	dialog_active = true
	set_buttons_enabled(false)
	await show_dialogue_timed("Billet", "Impossível... você carregou o peso... e não quebrou...", "res://sprites/characters/Boleto/billet_face.jpg")
	await show_dialogue_timed("Yume", "O peso do amanhã não é uma ameaça. É uma promessa. E eu vou cumprir a minha.", "res://dialog/assets/yumeFace.png")
	get_tree().change_scene_to_file("res://scenes/VictoryScreen.tscn")

func game_over():
	if is_game_over:
		return
	is_game_over = true
	dialog_active = true
	set_buttons_enabled(false)
	await show_dialogue_timed("Billet", "Eu avisei. O peso era grande demais pra você.", "res://sprites/characters/Boleto/billet_face.jpg")
	await show_dialogue_timed("Yume", "Eu... não estudei... o suficiente...", "res://dialog/assets/yumeFace.png")
	await show_dialogue_timed("Billet", "Não adianta chorar agora. O amanhã já chegou... e você não estava pronta.", "res://sprites/characters/Boleto/billet_face.jpg")
	get_tree().change_scene_to_file("res://scenes/game_over_scene.tscn")
