extends Node3D

var player_pos = Vector2.ZERO

func _physics_process(delta):
	global_position = cal_player_pos()

func cal_player_pos():
	var level_size = Vector2(Globals.current_level.viewport.size)
	var size_override = Vector2(Globals.current_level.viewport.size_2d_override)
	var pixel_size = Globals.current_level.sprite.pixel_size
	
	player_pos.y = size_override.y - player_pos.y # reverse y
	var pos = (player_pos * (level_size * pixel_size)) / size_override # position of player in meters
	
	var sprite_pos: Vector3 = Globals.current_level.sprite.global_position
	var sprite_pos_2d = Vector2(sprite_pos.x, sprite_pos.y)
	var sprite_size = level_size * Globals.current_level.sprite.pixel_size
	var sprite_corner = sprite_pos_2d
	sprite_corner.x -= sprite_size.x / 2
	sprite_corner.y -= sprite_size.y / 2
	var sprite_corner_3d = Vector3(sprite_corner.x, sprite_corner.y, sprite_pos.z) # position of sprite corner
	
	var player_pos_3d = sprite_corner_3d + Vector3(pos.x, pos.y, 0)
	return player_pos_3d
