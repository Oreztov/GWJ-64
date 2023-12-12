extends CanvasLayer

@export var value = 0
@export var decay = 0.1
var max_value = 100
var min_value = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	update()
	
func _physics_process(delta):
	value -= decay
	update()
	
func change_value(a):
	var tween = get_tree().create_tween()
	tween.tween_property(self, "value", value+a, 0.25)
	value = clamp(value, min_value, max_value)
	update()

func update():
	%ProgressBar.value = value
	%ProgressBar.min_value = min_value
	%ProgressBar.max_value = max_value
	
	var ratio = float(value) / float(max_value)
	%Pattern.material.set_shader_parameter("alpha", ratio / 50)
