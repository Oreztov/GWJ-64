extends Label

@export var answer: Globals.CLUES
var clue: Globals.CLUES

# Called when the node enters the scene tree for the first time.
func _ready():
	text = ""

func update_clue(new_clue):
	clue = new_clue
	text = Globals.clues[clue]

func _on_mouse_entered():
	MouseManager.answer = self


func _on_mouse_exited():
	MouseManager.answer = null
