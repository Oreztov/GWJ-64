extends CanvasLayer

@export var value = 0
@export var decay = 0.1
var max_value = 100
var min_value = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	$Control/Paused.hide()
	update()
	
func _physics_process(delta):
	value -= decay
	value = clamp(value, min_value, max_value)
	update()
	
func change_value(a):
	var tween = get_tree().create_tween()
	tween.tween_property(self, "value", value+a, 0.5)
	update()

func update():
	%ProgressBar.value = value
	%ProgressBar.min_value = min_value
	%ProgressBar.max_value = max_value
	
	var ratio = float(value) / float(max_value)
	%Pattern.material.set_shader_parameter("alpha", ratio / 25)
	%ENLIGHTENMENT.modulate.a = ratio + 0.25
	if linear_to_db(value) > 0:
		var volume_sfx = create_tween()
		volume_sfx.tween_property($sfxEnlightenment, "volume_db", linear_to_db(value/max_value), 300/1000)
		var volume_music = create_tween()
		volume_music.tween_property($musicLight, "volume_db", linear_to_db(value/max_value*2), 300/1000)
func set_objective(obj: Globals.OBJECTIVES):
	%Objective.text = Globals.objectives[obj]
	%GPUParticles2D.emitting = true
	
func set_overlay(value):
	%Pattern.visible = value


func _on_menu_button_pressed():
	get_tree().paused = !get_tree().paused
	$Control/Paused.visible = !$Control/Paused.visible


func _on_button_quit_pressed():
	get_tree().quit()


func _on_button_resume_pressed():
	_on_menu_button_pressed()
