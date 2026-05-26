extends Node2D
# Exemplo de variáveis para controlar o estado da pergunta
var resposta_correta = "A" # Supondo que a resposta correta seja a A

func _on_Btn1_pressed():
	print("Botão 1 clicado!")
	
	# 1. Verifica se a resposta foi correta
	if resposta_correta == "A":
		print("Resposta correta!")
		# Ação: avançar diálogo, tirar dano do boss, etc.
		avancar_dialogo_boss()
	else:
		print("Resposta errada!")
		# Ação: punição ou tentar novamente
		tratar_resposta_errada()

func avancar_dialogo_boss():
	# Aqui você chama a função que faz o boss falar a próxima frase
	# Exemplo: $Boss_Dialog.proxima_fala()
	pass

func tratar_resposta_errada():
	# Aqui você pode tocar um som de erro ou diminuir a vida da Yume
	pass
