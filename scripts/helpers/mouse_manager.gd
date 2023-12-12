extends CanvasLayer

@onready var poi_marker = $POIMarker

var on_poi = false

# Called when the node enters the scene tree for the first time.
func _ready():
	poi_marker.hide()

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
	poi_marker.visible = on_poi
	poi_marker.global_position = get_viewport().get_mouse_position()
	$POIMarker/Label.text = str(get_viewport().get_mouse_position())
	return col
