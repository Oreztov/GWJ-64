extends Area2D

@export var door_self: Globals.DOORS
@export var door_connected: Globals.DOORS

@export var level_from: Globals.LEVELS
@export var level_to: Globals.LEVELS

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func use_door():
	Globals.levels[level_from].exit()
	Globals.levels[level_to].enter()
	
	Globals.levels[level_to].player.position = Globals.doors[door_connected].position
	
	#play door sound
	if $AudioStreamPlayer.playing == false:
		$AudioStreamPlayer.play()
