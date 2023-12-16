extends Area2D

@export var inspectable: Globals.INSPECTABLES
@export var enlighten = 0
@export var single_use = false
@export var dialogue = ""
@export var await_signal = ""
@export var context = "Interact..."

var used = false

# Called when the node enters the scene tree for the first time.
func _ready():
	if await_signal != "":
		var s = FileData.get(await_signal)
		s.connect(inspect)


func inspect():
	if single_use and used:
		return
	# Inspect item
	if inspectable != null and inspectable != Globals.INSPECTABLES.Template:
		Globals.inspect_item.emit(inspectable)
	# Enlighten item
	if enlighten != 0:
		Enlightenment.change_value(enlighten)
	# Dialogue item
	if dialogue != "":
		Globals.open_dialogue.emit(dialogue)
	$AudioStreamPlayer.play()
	used = true
