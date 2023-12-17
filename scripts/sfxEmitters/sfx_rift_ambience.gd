extends Node3D
@export var light_threshold = 50

func _physics_process(delta):
	if Enlightenment.value <= light_threshold:
		if $AudioStreamPlayer3D.volume_db == 0:
			var volume_rift_amb = create_tween()
			volume_rift_amb.tween_property($AudioStreamPlayer3D, "volume_db", -80, 2)
	else:
		if $AudioStreamPlayer3D.volume_db == -80:
			var volume_rift_amb = create_tween()
			volume_rift_amb.tween_property($AudioStreamPlayer3D, "volume_db", 0, 0.3)
