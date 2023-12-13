extends CanvasLayer

var on_notebook = false
var on_clue = null

@onready var notebook = $Control/Notebook
@onready var image_orig = preload("res://sprites/UI/notebook_temp.png")
@onready var image = Image.new()

var draw_color = Color.BLACK
var near_pixels = [Vector2i(0, 1), Vector2i(0, -1), Vector2i(1, 0), Vector2i(-1, 0),
Vector2i(1, 1), Vector2i(1, -1), Vector2i(-1, 1), Vector2i(-1, -1)]

@onready var clue_scene = preload("res://scenes/UI/clue.tscn")

# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.notebook_ref = self
	image.copy_from(image_orig)
	$Control/Notebook/Instructions.hide()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if MouseManager.dragging_clue:
		return
	if on_notebook:
		if Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			if on_clue != null and not Globals.using_notebook:
				MouseManager.pickup_clue(on_clue)
				return
			Globals.using_notebook = true
			paint()
		elif Input.is_mouse_button_pressed(MOUSE_BUTTON_RIGHT):
			Globals.using_notebook = true
			erase()
		else:
			Globals.using_notebook = false
	else:
		Globals.using_notebook = false

func paint():
	var coordsi = get_coords()
	image.set_pixelv(coordsi, draw_color)
	for pixel in near_pixels:
		var new_coords = coordsi + pixel
		image.set_pixelv(new_coords, draw_color)
	update_texture()

func erase():
	var coordsi = get_coords()
	image.set_pixelv(coordsi, image_orig.get_pixelv(coordsi))
	var new_pixels = []
	for pixel in near_pixels:
		new_pixels.append(pixel)
		pixel *= 2
		new_pixels.append(pixel)
	for pixel in new_pixels:
		var new_coords = coordsi + pixel
		image.set_pixelv(new_coords, image_orig.get_pixelv(new_coords))
	update_texture()
	
func get_coords():
	var dis = get_viewport().get_mouse_position() - notebook.position
	var coords = dis * (Vector2(image.get_size()) / notebook.size)
	var coordsi = Vector2i(coords)
	return coordsi
	
func update_texture():
	notebook.texture = ImageTexture.create_from_image(image)
	
func add_clue(clue: Globals.CLUES):
	if not Globals.clues_obtained[clue]:
		var new_clue = clue_scene.instantiate()
		new_clue.clue = clue
		%ClueGrid.add_child(new_clue)
		Globals.clues_obtained[clue] = true
		$sfxNoteWrite.play()

func _on_open_button_pressed():
	$AnimationPlayer.play("move_in")
	$Control/Notebook/OpenButton.hide()
	$Control/Notebook/CloseButton.show()
	$Control/Notebook/Instructions.show()
	$sfxNoteOpen.play()


func _on_close_button_pressed():
	$AnimationPlayer.play("move_out")
	$Control/Notebook/OpenButton.show()
	$Control/Notebook/CloseButton.hide()
	$Control/Notebook/Instructions.hide()
	$sfxNoteClose.play()


func _on_reference_rect_mouse_entered():
	on_notebook = true


func _on_reference_rect_mouse_exited():
	on_notebook = false


func _on_clear_button_pressed():
	image.copy_from(image_orig)
	update_texture()


func _on_submit_button_pressed():
	var qna = $Control/Report/Puzzle1.get_children()
	var a = []
	for node in qna:
		if node.is_in_group("answers"):
			a.append(node)
	for answer in a:
		if answer.clue != answer.answer:
			set_answer_text("That's not quite right...") 
			return
	set_answer_text("Yes! That's it!") 
	
func set_answer_text(text):
	var label = $Control/Report/AnswerLabel
	label.modulate = Color(1,1,1,1)
	label.text = text
	var tween = get_tree().create_tween()
	tween.tween_property(label, "modulate", Color(1,1,1,0), 3)
	
