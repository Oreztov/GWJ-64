extends "res://scripts/objects/door.gd"

@export var light_threshold = 50

func _ready():
	super()
	if interact_disabled:
		set_physics_process(false)

func _physics_process(delta):
	if Enlightenment.value >= light_threshold:
		interact_disabled = false
		$GPUParticles2D.process_material.gravity.y = 98
		$GPUParticles2D.process_material.scale_min = 6
		$GPUParticles2D.process_material.scale_max = 6
	else:
		interact_disabled = true
		$GPUParticles2D.process_material.gravity.y = 33
		$GPUParticles2D.process_material.scale_min = 3
		$GPUParticles2D.process_material.scale_max = 3
		
