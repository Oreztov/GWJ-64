extends Node3D

@export var camera_distance = 3 # Meters on the z axis

@onready var camera = $Camera3D

# Called when the node enters the scene tree for the first time.
func _ready():
	# Get levels
	for viewport in $LevelViewports.get_children():
		var level = viewport.get_child(0)
		# Set the level variables
		level.viewport = viewport
		level.sprite = get_node("LevelSprites/" + level.name)
		# Add to list
		level.init()
		Globals.levels[level.index] = level
	
	Globals.level_changed.connect(level_changed)
	Globals.player_moved.connect(player_moved)
	
	Globals.levels[Globals.LEVELS.LEVEL1].enter()

func player_moved():
	var size = Vector2(Globals.current_level.viewport.size)
	camera.global_position.x += Globals.player_delta.x / size.x
	camera.global_position.y -= Globals.player_delta.y / size.y
	
func level_changed(position_delta):
	# Adjust camera
	camera.global_position.x += position_delta.x
	camera.global_position.y += position_delta.y
	camera.global_position.z = Globals.current_level.sprite.global_position.z + camera_distance
	# Fade layers close to camera
	for i in Globals.levels:
		var level = Globals.levels[i]
		var factor = (camera.global_position.z - level.sprite.global_position.z) / camera_distance
		level.sprite.modulate.a = factor

