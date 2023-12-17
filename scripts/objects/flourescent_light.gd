extends Node2D

@onready var animated_sprite_2d = $AnimatedSprite2D

func _ready():
	var light_manager = get_tree().get_first_node_in_group("Light manager") as LightManager
	light_manager.flicker_lights.connect(flicker_lights)


func flicker_lights():
	animated_sprite_2d.play("FLICKER")
