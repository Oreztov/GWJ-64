extends Node
class_name LightManager

@onready var timer = $Timer

signal flicker_lights

func _ready():
	get_random_interval()
	
	timer.timeout.connect(on_timer_timeout)

func get_random_interval() -> void:
	var random_wait_time = randf_range(10, 20)
	
	timer.wait_time = random_wait_time
	timer.start()


func on_timer_timeout():
	flicker_lights.emit()
	get_random_interval()
