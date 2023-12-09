extends Area2D

@export var inspectable: Globals.INSPECTABLES

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func inspect():
	Globals.inspect_item.emit(inspectable)
