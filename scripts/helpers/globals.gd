extends Node

var camera_distance = 4 # Meters on the z axis
var player_pos = Vector2(0, 0)

var using_notebook = false

# Name is floor (y), number is layer (z)
enum LEVELS {GroundFloor1, GroundFloor2, GroundFloor3, Basement1, Basement2, FirstFloor2, FirstFloor3}
var levels = {}
var current_level

enum DOORS {DoorGF1ToGF2, DoorGF2ToGF1, DoorGF2ToGF3, DoorGF3ToGF2,
DoorB1ToB2, DoorB2ToB1,
DoorFF2ToFF3, DoorFF3ToFF2,
StairsGF1ToB1, StairsB1ToGF1, StairsGF3ToFF3, StairsFF3ToGF3}
var doors = {}

enum INSPECTABLES {Template, DinoPlush, Squirrel}
var inspectables = {}
var inspectables_path = "res://scenes/inspectables"

enum CLUES {DinoOwner}
var clues = {
	CLUES.DinoOwner: "Simey H."
}

signal level_changed
signal inspect_item

func _ready():
	# Get Inspectables
	var inspecties = list_files_in_directory(inspectables_path)
	for inspect in inspecties:
		var file = load(inspectables_path + "/" + inspect)
		inspectables[file.instantiate().id] = file
	
func list_files_in_directory(path):
	var files = []
	var dir = DirAccess.open(path)
	
	dir.list_dir_begin()

	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with("."):
			files.append(file)

	dir.list_dir_end()

	return files
	
func cal_3d_pos(level: Level, pos_orig: Vector2):
	var level_size = Vector2(Globals.current_level.viewport.size)
	var size_override = Vector2(Globals.current_level.viewport.size_2d_override)
	var pixel_size = Globals.current_level.sprite.pixel_size
	
	pos_orig.y = size_override.y - pos_orig.y # reverse y
	var pos = (pos_orig * (level_size * pixel_size)) / size_override # position of player in meters
	
	var sprite_pos: Vector3 = Globals.current_level.sprite.global_position
	var sprite_pos_2d = Vector2(sprite_pos.x, sprite_pos.y)
	var sprite_size = level_size * Globals.current_level.sprite.pixel_size
	var sprite_corner = sprite_pos_2d
	sprite_corner.x -= sprite_size.x / 2
	sprite_corner.y -= sprite_size.y / 2
	var sprite_corner_3d = Vector3(sprite_corner.x, sprite_corner.y, sprite_pos.z) # position of sprite corner
	
	var pos_3d = sprite_corner_3d + Vector3(pos.x, pos.y, 0)
	return pos_3d
