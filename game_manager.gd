extends Node

# Estado atual
enum Estado { START, ROOM, FLOREST, CEMETERY, BOSS, GAMEOVER, PAUSE }
var estado_atual = Estado.START
var jogo_pausado = false
var ultima_fase = "Room"
var pause_node = null

# 🔥 Dicionário para controlar quais diálogos já foram vistos
var dialogos_vistos = {
	"Florest": false,
	"Cemetery": false,

}

func _ready():
	pass

# ============ CARREGAMENTO DE CENAS ============
func carregar_start():
	get_tree().change_scene_to_file("res://scenes/start_scene.tscn")

func iniciar_novo_jogo():
	ultima_fase = "Room"
	# 🔥 Reseta TODOS os diálogos
	for fase in dialogos_vistos:
		dialogos_vistos[fase] = false
	salvar_jogo()
	get_tree().change_scene_to_file("res://scenes/room.tscn")

func continuar_jogo():
	carregar_save()
	match ultima_fase:
		"Room":
			get_tree().change_scene_to_file("res://scenes/room.tscn")
		"Florest":
			get_tree().change_scene_to_file("res://scenes/florest.tscn")
		"Cemetery":
			get_tree().change_scene_to_file("res://scenes/cemetery.tscn")
		"Fase_Boss":
			get_tree().change_scene_to_file("res://scenes/fase_boss.tscn")
		_:
			get_tree().change_scene_to_file("res://scenes/room.tscn")

func avancar_para_florest():
	ultima_fase = "Florest"
	salvar_jogo()
	get_tree().change_scene_to_file("res://scenes/florest.tscn")

func completar_florest():
	ultima_fase = "Cemetery"
	salvar_jogo()
	get_tree().change_scene_to_file("res://scenes/cemetery.tscn")

func completar_cemetery():
	ultima_fase = "Fase_Boss"
	salvar_jogo()
	get_tree().change_scene_to_file("res://scenes/fase_boss.tscn")

func completar_boss():
	deletar_save()
	get_tree().change_scene_to_file("res://scenes/start_scene.tscn")

func game_over():
	get_tree().change_scene_to_file("res://scenes/game_over_scene.tscn")

func reiniciar_jogo():
	iniciar_novo_jogo()

func voltar_menu():
	get_tree().change_scene_to_file("res://scenes/start_scene.tscn")

# ============ PAUSA ============
func pausar():
	if not jogo_pausado:
		jogo_pausado = true
		pause_node = load("res://scenes/pause_scene.tscn").instantiate()
		if pause_node:
			get_tree().root.add_child(pause_node)
			pause_node.process_mode = Node.PROCESS_MODE_ALWAYS
		get_tree().paused = true

func retomar():
	if jogo_pausado:
		jogo_pausado = false
		get_tree().paused = false
		if pause_node:
			pause_node.queue_free()
			pause_node = null

func reiniciar_fase_atual():
	var cena_atual = get_tree().current_scene.scene_file_path
	if jogo_pausado:
		retomar()
	get_tree().change_scene_to_file(cena_atual)

func desistir():
	retomar()
	get_tree().change_scene_to_file("res://scenes/start_scene.tscn")

# 🔥 FUNÇÃO GENÉRICA: Marca diálogo de uma fase como visto
func completar_dialogo(fase_nome: String):
	if dialogos_vistos.has(fase_nome):
		dialogos_vistos[fase_nome] = true
		salvar_jogo()
		print("💾 Diálogo da ", fase_nome, " marcado como visto!")

# 🔥 FUNÇÃO GENÉRICA: Verifica se diálogo já foi visto
func dialogo_visto(fase_nome: String) -> bool:
	return dialogos_vistos.get(fase_nome, false)

# ============ SISTEMA DE SAVE ============
func salvar_jogo():
	var config = ConfigFile.new()
	config.set_value("progresso", "ultima_fase", ultima_fase)
	config.set_value("progresso", "dialogos_vistos", dialogos_vistos)
	config.save("user://savegame.cfg")
	print("💾 Jogo salvo - Fase: ", ultima_fase, " | Diálogos: ", dialogos_vistos)

func carregar_save():
	var config = ConfigFile.new()
	if config.load("user://savegame.cfg") == OK:
		ultima_fase = config.get_value("progresso", "ultima_fase", "Room")
		dialogos_vistos = config.get_value("progresso", "dialogos_vistos", {
			"Room": false, "Florest": false, "Cemetery": false, "Fase_Boss": false
		})
		print("📀 Save carregado - Fase: ", ultima_fase, " | Diálogos: ", dialogos_vistos)
	else:
		ultima_fase = "Room"
		dialogos_vistos = {"Room": false, "Florest": false, "Cemetery": false, "Fase_Boss": false}

func save_existe():
	return FileAccess.file_exists("user://savegame.cfg")

func deletar_save():
	if save_existe():
		DirAccess.remove_absolute("user://savegame.cfg")
		print("🗑️ Save deletado!")

func sair_jogo():
	deletar_save()
	get_tree().quit()
