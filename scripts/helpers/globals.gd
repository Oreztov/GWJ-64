extends Node

var camera_distance = 2 # Meters on the z axis
var player_pos = Vector2(0, 0)

var using_notebook = false
var notebook_ref = null

# Name is floor (y), number is layer (z)
enum LEVELS {GroundFloor1, GroundFloor2, GroundFloor3, 
Basement1, Basement2, Basement3, 
FirstFloor2, FirstFloor3,
Tutorial1, Tutorial2, Tutorial3,
Rift1, Rift2
}
var levels = {}
var current_level = null

enum DOORS {DoorGF1ToGF2, DoorGF2ToGF1, DoorGF2ToGF3, DoorGF3ToGF2,
DoorB1ToB2, DoorB2ToB1, DoorB2ToB3, DoorB3ToB2,
DoorFF2ToFF3, DoorFF3ToFF2,
StairsGF1ToB1, StairsB1ToGF1, StairsGF3ToFF3, StairsFF3ToGF3,
HoleGF3ToB3, HoleB3ToGF3,
DoorFF22ToFF3,
DoorT1ToT2, DoorT2ToT1, RiftT2ToT3, RiftT3ToT2, DoorT3ToGF1, DoorGF1ToT3,
RiftB1ToR1, RiftR1ToB1,
Decor,
RiftGF2ToR2, RiftR2ToGF2
}
var doors = {}

enum INSPECTABLES {Template, DinoPlush, Squirrel, Body, Bucket, Cart, MedicalBox}
var inspectables = {}
var inspectables_path = "res://scenes/inspectables"

enum CLUES {Template, DinoOwner, 
Knife, Bat, Gloves, Poison, 
Stabbing, Bruises, Asphyxiation,
Code1, Code2, Code3, Code4,
Crowbar
}
var clues = {
	CLUES.Template: "Template",
	CLUES.DinoOwner: "Simey H.",
	CLUES.Knife: "Ritual Knife",
	CLUES.Bat: "Baseball Bat",
	CLUES.Gloves: "Medical Gloves",
	CLUES.Poison: "Poison Syringe",
	CLUES.Stabbing: "Stab Wounds",
	CLUES.Bruises: "Bruise Marks",
	CLUES.Asphyxiation: "Asphyxiation",
	CLUES.Code1: "8654",
	CLUES.Code2: "1902",
	CLUES.Code3: "3591",
	CLUES.Code4: "9276",
	CLUES.Crowbar: "Crowbar"
}
var clues_obtained = {}


enum PUZZLES {PuzzleTutorial, Puzzle1}
var puzzles = { # First value is string name of the puzzle node name in notebook
	PUZZLES.PuzzleTutorial: ["PuzzleTutorial", CLUES.Code1],
	PUZZLES.Puzzle1: ["Puzzle1", CLUES.Poison, CLUES.Asphyxiation]
}
var puzzles_completed = {}

enum OBJECTIVES {Empty,
TutorialStart, TutorialReport, TutorialEnd,
MainFindBody, MainDeathReport,
GoToEnding, EnterEnding
}
var objectives = {
	OBJECTIVES.Empty: "",
	OBJECTIVES.TutorialStart: "- Move into the hideout.",
	OBJECTIVES.TutorialReport: "- Report the right code.",
	OBJECTIVES.TutorialEnd: "- Enter the hideout.",
	OBJECTIVES.MainFindBody: "- Find the missing person.",
	OBJECTIVES.MainDeathReport: "- Report on the murder.",
	OBJECTIVES.GoToEnding: "- Talk to the guard on the first floor.",
	OBJECTIVES.EnterEnding: "- Proceed into the chamber."
}

var active_puzzle = null
var answers = []

signal enter_game
signal intro_done
signal level_changed
signal inspect_item

signal open_dialogue
signal close_dialogue
signal puzzle_complete
signal event

signal tutorial_2
signal tutorial_3
signal tutorial_4

func _ready():
	# Get Inspectables
	var inspecties = list_files_in_directory(inspectables_path)
	for file in FileData.inspectables:
		inspectables[file.instantiate().id] = file
	# Set clues
	for i in len(CLUES):
		clues_obtained[i] = false
	# Set puzzles
	for i in len(PUZZLES):
		puzzles_completed[i] = false
		
	puzzle_complete.connect(puzz_done)
	
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

func puzz_done(puzzle):
	match puzzle:
		PUZZLES.PuzzleTutorial:
			Enlightenment.set_objective(OBJECTIVES.TutorialEnd)
		PUZZLES.Puzzle1:
			Enlightenment.set_objective(OBJECTIVES.GoToEnding)
			
