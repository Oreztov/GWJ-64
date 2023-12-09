extends CharacterBody2D

const SPEED = 600.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var near_door = false
var door = null

var prev_pos = global_position

var input_enabled = false

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	if input_enabled:
		var direction = Input.get_axis("move_left", "move_right")
		if direction:
			velocity.x = direction * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)

		move_and_slide()
		
		if Input.is_action_just_pressed("use_door") and near_door and door != null:
			door.use_door()
		
		if velocity != Vector2(0, 0):
			Globals.player_moved.emit()
		
	Globals.player_delta = global_position - prev_pos
	prev_pos = global_position


func _on_area_2d_area_entered(area):
	if area.is_in_group("doors"):
		near_door = true
		door = area

func _on_area_2d_area_exited(area):
	if area.is_in_group("doors"):
		near_door = false
		door = area
