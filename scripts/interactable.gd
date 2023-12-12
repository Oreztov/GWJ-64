extends Area2D

@export var inspectable: Globals.INSPECTABLES
@export var enlighten = 0
@export var single_use = false
var used = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func inspect():
	if single_use and used:
		return
	# Inspect item
	if inspectable != null and inspectable != Globals.INSPECTABLES.Template:
		Globals.inspect_item.emit(inspectable)
	# Enlighten item
	elif enlighten != 0:
		Enlightenment.change_value(enlighten)
	$AudioStreamPlayer.play()
	used = true
