extends "res://scripts/objects/door.gd"

@export var light_threshold = 50
var is_interactable = true

func _ready():
	super()
	is_interactable = not interact_disabled

func _physics_process(delta):
	if Enlightenment.value >= light_threshold:
		interact_disabled = false
		show()
	else:
		if is_interactable:
			interact_disabled = true
		hide()
