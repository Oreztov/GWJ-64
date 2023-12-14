extends "res://scripts/interactable.gd"

@export var await_puzzle: Globals.PUZZLES
@export var new_dialogue = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.puzzle_complete.connect(update)
		
func update():
	if Globals.puzzles_completed[await_puzzle]:
		dialogue = new_dialogue

