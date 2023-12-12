extends Area2D

@export var inspectable: Globals.INSPECTABLES
@export var enlighten = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func inspect():
	# Inspect item
	if inspectable != null and inspectable != Globals.INSPECTABLES.Template:
		Globals.inspect_item.emit(inspectable)
	# Enlighten item
	elif enlighten != 0:
		Enlightenment.change_value(enlighten)
	$AudioStreamPlayer.play()
