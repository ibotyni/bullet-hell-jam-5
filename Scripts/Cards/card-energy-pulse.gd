extends Control

@export var power_level : int = 1:
	set(value):
		if value < 1:
			value = 1
		elif value > 5:
			value = 5
		power_level = value
		
# Called when the node enters the scene tree for the first time.
func _ready():
	# weakest power is yellow, strongest is red
	var yellowness : float = ((5-power_level) * 50.0) / 255
	$"card-frame/bullet".texture = load("res://Assets/Artwork/bullets/pulse-0{power}.png".format({"power" : power_level}))
	$"card-frame".material.set_shader_parameter("custom_color", Color(1,yellowness,0,1))

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
