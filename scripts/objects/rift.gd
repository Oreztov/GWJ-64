extends "res://scripts/objects/door.gd"

@export var light_threshold = 50
var is_interactable = true

func _ready():
	super()
	if interact_disabled:
		is_interactable = false

func _physics_process(delta):
	if Enlightenment.value >= light_threshold:
		if is_interactable:
			interact_disabled = false
			$Sprite2D.show()
	else:
		interact_disabled = true
		$Sprite2D.hide()
