extends CanvasLayer

var on_notebook = false
var drawing = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_open_button_pressed():
	$AnimationPlayer.play("move_in")
	$Control/Notebook/OpenButton.hide()
	$Control/Notebook/CloseButton.show()


func _on_close_button_pressed():
	$AnimationPlayer.play("move_out")
	$Control/Notebook/OpenButton.show()
	$Control/Notebook/CloseButton.hide()


func _on_reference_rect_mouse_entered():
	on_notebook = true


func _on_reference_rect_mouse_exited():
	on_notebook = false
