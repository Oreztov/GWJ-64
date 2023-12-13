extends CanvasLayer

@onready var poi_marker = $POIMarker
@onready var clue_text = $Clue

var on_poi = false
var dragging_clue = false
var clue = null
var answer = null

# Called when the node enters the scene tree for the first time.
func _ready():
	poi_marker.hide()
	
func _process(delta):
	clue_text.position = get_viewport().get_mouse_position()
	if dragging_clue:
		if !Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT):
			drop_clue()
	
		

func check_poi(raycast: RayCast3D, camera: Camera3D, depth):
	show()
	var pos = camera.project_position(get_viewport().get_mouse_position(), depth)
	raycast.position.x = pos.x
	raycast.position.y = pos.y
	on_poi = false
	var col = null
	if raycast.is_colliding():
		col = raycast.get_collider()
		if col.is_in_group("POIs"):
			on_poi = true
		else:
			col = null
	poi_marker.global_position = get_viewport().get_mouse_position()
	return col
	
func pickup_clue(new_clue: Globals.CLUES):
	clue = new_clue
	clue_text.text = Globals.clues[clue]
	dragging_clue = true
	
func drop_clue():
	if answer != null:
		answer.update_clue(clue)
	clue = null
	clue_text.text = ""
	dragging_clue = false
	
