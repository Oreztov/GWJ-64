extends Node3D

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
	
	PlayerTracker.global_position = $PlayerStartPos.global_position
	
	Globals.levels[Globals.LEVELS.LEVEL1].enter()
	
	$Camera3D/AudioListener3D.position.z -= Globals.camera_distance #offset listener

func player_moved():
	update_camera()
	
func level_changed(position_delta):
	# Adjust camera
	update_camera()
	# Fade layers close to camera
	for i in Globals.levels:
		var level = Globals.levels[i]
		var factor = (camera.global_position.z - level.sprite.global_position.z) / Globals.camera_distance
		if factor >= 1:
			level.sprite.modulate.a = factor
		else:
			level.sprite.modulate.a = factor
		
func update_camera():
	camera.global_position = PlayerTracker.global_position
	camera.global_position.z += Globals.camera_distance
	#$Camera3D/AudioListener3D.position = PlayerTracker.global_position #for debugging
