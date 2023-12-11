extends Node

var camera_distance = 4 # Meters on the z axis
var player_delta = Vector2(0, 0)

var using_notebook = false

enum LEVELS {LEVEL1, LEVEL2, LEVEL3}
var levels = {}
var current_level

enum DOORS {Door1To2, Door2To1, Door2To3, Door3To2}
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
