extends Node2D

@onready var player = $Player

func enter():
	player.set_physics_process(true)
	player.show()
	
func exit():
	player.set_physics_process(false)
	player.hide()

# Called when the node enters the scene tree for the first time.
func _ready():
	for door in $Doors.get_children():
		Globals.doors[door.door_self] = door
	exit()
