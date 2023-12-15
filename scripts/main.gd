extends Node3D

@onready var camera = $Camera3D
@onready var listener = $Camera3D/AudioListener3D

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
	
	# Start game
	Globals.levels[Globals.LEVELS.Tutorial1].enter()
	Enlightenment.set_objective(Globals.OBJECTIVES.TutorialStart)
	
	#set listener z offset
	listener.global_position.z = Globals.cal_3d_pos(Globals.current_level, Globals.player_pos).z + 0.1
	
func _process(delta):
	update_camera()
	$DirectionalLight3D.light_energy = float(Enlightenment.value) / float(Enlightenment.max_value) + 0.15

func level_changed():
	# Fade layers close to camera
	for i in Globals.levels:
		var level = Globals.levels[i]
		var factor = (camera.global_position.z - level.sprite.global_position.z) / Globals.camera_distance
		if factor >= 1:
			level.sprite.modulate.a = factor
		else:
			level.sprite.modulate.a = factor
	
	#set listener z offset
	listener.global_position.z = Globals.cal_3d_pos(Globals.current_level, Globals.player_pos).z + 0.1
func update_camera():
	level_changed()
	camera.global_position = Globals.cal_3d_pos(Globals.current_level, Globals.player_pos)
	camera.global_position.z += Globals.camera_distance
	
	#listener.global_position = Globals.cal_3d_pos(Globals.current_level, Globals.player_pos)
