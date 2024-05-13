extends Control

@onready var score = $Score:
	set(value):
		score.text = "Score: " + str(value)

@onready var wallet = $MoolaDisplay:
	set(value):
		wallet.text = "X: " + str(value)
