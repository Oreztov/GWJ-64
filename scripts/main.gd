extends Node3D

@onready var level1 = $Level1Viewport.get_child(0)
@onready var level2 = $Level2Viewport.get_child(0)

# Called when the node enters the scene tree for the first time.
func _ready():
	# Connect viewports to sprites
	$Levels/Level1.texture.viewport_path = "Level1Viewport"
	$Levels/Level2.texture.viewport_path = "Level2Viewport"
	
	# Connect levels to nodes
	Globals.levels[Globals.LEVELS.LEVEL1] = level1
	Globals.levels[Globals.LEVELS.LEVEL2] = level2
	
	level1.enter()
	
func _physics_process(delta):
	$Camera3D.global_position.x = Globals.player_pos.x / 500
	$Camera3D.global_position.y = Globals.player_pos.y / 500
	

