extends Label

@export var clue: Globals.CLUES


# Called when the node enters the scene tree for the first time.
func _ready():
	text = Globals.clues[clue]

