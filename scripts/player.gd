extends CharacterBody2D


const SPEED = 600.0
const JUMP_VELOCITY = -400.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var near_door = false
var door = null

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
	if Input.is_action_just_pressed("ui_up") and near_door and door != null:
		door.use_door()
	
	Globals.player_pos = position
	


func _on_area_2d_area_entered(area):
	if area.is_in_group("doors"):
		near_door = true
		door = area

func _on_area_2d_area_exited(area):
	if area.is_in_group("doors"):
		near_door = false
		door = area
