extends "res://scripts/interactable.gd"

@export var await_puzzle: Globals.PUZZLES
@export var new_dialogue = ""

# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.puzzle_complete.connect(update)
	Globals.close_dialogue.connect(dialogue_done)
	
func inspect():
	super()
	$AnimatedSprite2D.play("interact")

func dialogue_done():
	$AnimatedSprite2D.play("idle")
		
func update(puzzle):
	if new_dialogue != "":
		if await_puzzle == puzzle:
			dialogue = new_dialogue

