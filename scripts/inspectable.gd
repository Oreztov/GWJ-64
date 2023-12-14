class_name Inspectable extends Node3D

@export var id: Globals.INSPECTABLES
@export var title: String
@export var clues: Array[Globals.CLUES]
var clues_areas = []

func _ready():
	for i in range(len(clues)):
		for area in $POIs.get_children():
			if area.is_in_group(str(i)):
				clues_areas.append(area)
				
func get_clue(clue_area):
	var i = clues_areas.find(clue_area)
	return clues[i]
