extends Label

@export var clue: Globals.CLUES


# Called when the node enters the scene tree for the first time.
func _ready():
	text = Globals.clues[clue]



func _on_mouse_entered():
	Globals.notebook_ref.on_clue = clue


func _on_mouse_exited():
	Globals.notebook_ref.on_clue = null
