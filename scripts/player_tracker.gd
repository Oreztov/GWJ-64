extends Node3D

func _ready():
	Globals.level_changed.connect(level_changed)
	Globals.player_moved.connect(player_moved)

func player_moved():
	var size = Vector2(Globals.current_level.viewport.size)
	global_position.x += Globals.player_delta.x / size.x
	global_position.y -= Globals.player_delta.y / size.y
	
func level_changed(position_delta):
	global_position.x += position_delta.x
	global_position.y += position_delta.y
	global_position.z = Globals.current_level.sprite.global_position.z
