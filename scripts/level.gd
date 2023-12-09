extends Node2D

func enter():
	set_physics_process(true)
	$Player.set_physics_process(true)
	
func exit():
	set_physics_process(false)
	$Player.set_physics_process(false)

# Called when the node enters the scene tree for the first time.
func _ready():
	exit()
