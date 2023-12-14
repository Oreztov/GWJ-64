extends Node3D

@export var inspectables: Array[PackedScene]
@export var dialogue: Array[DialogueData]

signal open_tutorial_gate
var signals = [open_tutorial_gate]
