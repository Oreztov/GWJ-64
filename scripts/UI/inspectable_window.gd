extends CanvasLayer

var dragging = false
var current_inspect = null

# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.inspect_item.connect(inspect_item)
	set_process_input(false)
	hide()
	
func _input(event):
	if not Globals.using_notebook:
		# Check for clicking on POI
		var col = MouseManager.check_poi($Inspectable/POIRaycast, $Inspectable/Camera3D, 3)
		if col != null:
			if !Globals.clues_obtained[current_inspect.get_clue(col)]:
				if not MouseManager.poi_marker.visible:
					$sfxSpotPOI.play()
				MouseManager.poi_marker.show()
				if event is InputEventMouseButton:
					if event.is_pressed():
						Globals.notebook_ref.add_clue(current_inspect.get_clue(col))
			else:
				MouseManager.poi_marker.hide()
		else:
			MouseManager.poi_marker.hide()
					
					
		if event is InputEventMouseButton:
			# Check for camera dragging
			if event.is_pressed():
				dragging = true
			else:
				dragging = false
		elif event is InputEventMouseMotion and dragging:
			$Inspectable/InspectableModel.rotation.x += event.relative.y / 100
			$Inspectable/InspectableModel.rotation.y += event.relative.x / 100
	else:
		dragging = false

func inspect_item(item):
	# Get inspectable
	var inspectable = Globals.inspectables[item]
	var ins = inspectable.instantiate()
	# Set inspectable
	$Inspectable/InspectableModel.add_child(ins)
	$VBoxContainer/Title.text = ins.title
	$VBoxContainer/Description.text = ins.description
	# Open menu
	$Inspectable/InspectableModel.rotation = Vector3.ZERO
	set_process_input(true)
	Globals.current_level.player.input_enabled = false
	show()
	current_inspect = ins

func close_menu():
	# Clear models
	var models = $Inspectable/InspectableModel.get_children()
	for model in models:
		model.queue_free()
	# Close menu
	set_process_input(false)
	MouseManager.hide()
	Globals.current_level.player.input_enabled = true
	hide()
	current_inspect = null


func _on_close_button_pressed():
	close_menu()
