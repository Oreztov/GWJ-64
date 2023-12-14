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
	Globals.open_dialogue.connect(open_dialogue)
	
	Globals.tutorial_2.connect(tutorial_2)
	Globals.tutorial_3.connect(tutorial_3)
	Globals.tutorial_4.connect(tutorial_4)
	
	tutorial_1()
	

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
	if Globals.active_puzzle != null:
		var puzzle = $Control/Report.get_node(Globals.puzzles[Globals.active_puzzle][0])
		var qna = puzzle.get_children()
		var a = []
		for node in qna:
			if node.is_in_group("answers"):
				a.append(node)
		for answer in a:
			if answer.clue != answer.answer:
				set_answer_text("That's not quite right...") 
				return
		set_answer_text("Yes! That's it!")
		complete_puzzle()
	
func set_answer_text(text):
	var label = $Control/Report/AnswerLabel
	label.modulate = Color(1,1,1,1)
	label.text = text
	var tween = get_tree().create_tween()
	tween.tween_property(label, "modulate", Color(1,1,1,0), 3)
	
func open_dialogue(dialogue = ""):
	for d in FileData.dialogue:
		var d_path = d.resource_path
		var ds = d_path.split("/")
		if dialogue == ds[len(ds)-1]:
			$Control/DialogueBox.dialogue_data = d
			$Control/DialogueBox.start()
			Globals.current_level.player.input_enabled = false
			
func set_puzzle(puzzle: Globals.PUZZLES):
	Globals.active_puzzle = puzzle
	for node in $Control/Report.get_children():
		if node.is_in_group("puzzles"):
			node.hide()
	$Control/Report.get_node(Globals.puzzles[Globals.active_puzzle][0]).show()
	$Control/Report/SubmitButton.text = "SUBMIT"
	$Control/Report/SubmitButton.disabled = false
	
func complete_puzzle():
	Globals.puzzles_completed[Globals.active_puzzle] = true
	for node in $Control/Report.get_children():
		if node.is_in_group("puzzles"):
			node.hide()
	Globals.active_puzzle = null
	Globals.puzzle_complete.emit()
	$Control/Report/SubmitButton.text = "Nothing to report..."
	$Control/Report/SubmitButton.disabled = true
	
	
func tutorial_1():
	$Control/TutorialBox.start_id = "T1"
	$Control/TutorialBox.start()
	
func tutorial_2():
	$Control/TutorialBox.start_id = "T2"
	$Control/TutorialBox.start()
	
func tutorial_3():
	$Control/TutorialBox.start_id = "T3"
	$Control/TutorialBox.start()

func tutorial_4():
	$Control/TutorialBox.start_id = "T4"
	$Control/TutorialBox.start()
	
func _on_dialogue_box_dialogue_ended():
	Globals.current_level.player.input_enabled = true

func _on_dialogue_box_dialogue_signal(value):
	match(value):
		'puzzle_tutorial': 
			set_puzzle(Globals.PUZZLES.PuzzleTutorial)
			Globals.tutorial_4.emit()
		'open_tutorial_gate':
			FileData.open_tutorial_gate.emit()
