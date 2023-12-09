class_name Level extends Node2D

@export var index: Globals.LEVELS
# Will be set once instantiated from main
var sprite: Sprite3D = null
var viewport: SubViewport = null

@onready var player = $Player

func init():
	# Assign viewport texture to sprite
	sprite.texture.viewport_path = "LevelViewports/" + viewport.name
	viewport.size_2d_override = get_viewport_rect().size

func enter(position_delta = Vector2.ZERO):
	player.set_physics_process(true)
	player.show()
	Globals.current_level = self
	Globals.level_changed.emit(position_delta)
	
func exit():
	player.set_physics_process(false)
	player.hide()

# Called when the node enters the scene tree for the first time.
func _ready():
	for door in $Doors.get_children():
		Globals.doors[door.door_self] = door
	exit()
