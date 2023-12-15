extends Area2D

@export var set_obj: Globals.OBJECTIVES
@export var event = ""

func _on_body_entered(body):
	if body.is_in_group("players"):
		Enlightenment.set_objective(set_obj)
		Globals.event.emit(event)
		set_deferred("monitorable", false)
		set_deferred("monitoring", false)
