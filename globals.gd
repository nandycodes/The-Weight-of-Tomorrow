extends Node

var player_health = 5
var max_health = 5

# Esse sinal avisa quando a vida mudar
signal health_changed(new_health)

func take_damage(amount):
	player_health -= amount
	player_health = max(0, player_health)
	health_changed.emit(player_health) # Avisa todo mundo
