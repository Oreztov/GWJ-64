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

func enter():
	player.set_physics_process(true)
	player.show()
	Globals.current_level = self
	Globals.level_changed.emit()
	$Timers/EnterDoorTimer.start()
	
func exit():
	player.set_physics_process(false)
	player.hide()
	player.input_enabled = false

# Called when the node enters the scene tree for the first time.
func _ready():
	for door in $Doors.get_children():
		Globals.doors[door.door_self] = door
	exit()


func _on_enter_door_timer_timeout():
	player.input_enabled = true
