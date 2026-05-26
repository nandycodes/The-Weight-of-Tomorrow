extends Node2D

func _ready():
	# Conecta o sinal do zumbi para revelar a alavanca quando ele morrer
	if has_node("Zumbi"):
		$Zumbi.morreu.connect(_on_zumbi_morreu)
		
	# Ajuste da Câmera para travar exatamente no limite do portão
	if has_node("Yume") and $Yume.has_node("Camera2D"):
		$Yume/Camera2D.limit_right = 3680 # Impede de mostrar o fundo preto além do portão

func _on_zumbi_morreu():
	# Faz a alavanca e o texto "Pressione E" aparecerem no chão
	if has_node("Lever"):
		$Lever.visible = true
		if $Lever.has_node("Label"):
			$Lever/Label.visible = true
		print("Zumbi derrotado! Alavanca liberada.")

# --- INTERAÇÃO COM A ALAVANCA ---
# Chame esta função no script da Yume (usando get_parent().abrir_portao()) quando ela apertar 'E'
func abrir_portao():
	if has_node("portao"):
		$portao.visible = false # Faz o portão sumir visualmente
		
		# Desativa a colisão física do portão para a Yume conseguir passar pelo vão
		if $portao.has_node("CollisionShape2D"):
			$portao/CollisionShape2D.set_deferred("disabled", true)
		print("O portão se abriu! O caminho pelo buraco está livre.")

# --- GATILHO INVISÍVEL QUE MUDA DE FASE ---
# Certifique-se de que o sinal 'body_entered' do seu gatilhofase está conectado aqui!
func _on_gatilhofase_body_entered(body):
	# Se quem pisou no meio do portão foi a Yume, muda de cena
	if body.name == "Yume":
		print("Yume passou pelo portão! Carregando a fase do Boss...")
		
		# Muda para a cena do Cup Boss (confira se o nome do arquivo está certinho na sua pasta)
		get_tree().change_scene_to_file("res://fase_boss.tscn")
