extends CharacterBody2D

const SPEED = 600.0

@onready var player_sprite = %AnimatedPlayerSprite as AnimatedSprite2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var near_door = false
var door = null

var near_interactable = false
var interactable = null

var prev_pos = global_position

var input_enabled = false

func _ready():
	$PromptInteract.hide()
	$PromptDoor.hide()

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	if input_enabled:
		var direction = Input.get_axis("move_left", "move_right")
		if direction:
			if direction == -1:
				player_sprite.scale.x = -2
			else:
				player_sprite.scale.x = 2
			
			player_sprite.play("Walk")
			velocity.x = direction * SPEED
		else:
			player_sprite.play("Idle")
			velocity.x = move_toward(velocity.x, 0, SPEED)

		move_and_slide()
		
		# Use Doors
		if near_door and door != null:
			$PromptDoor.show()
			if Input.is_action_just_pressed("use_door"):
				door.use_door()
		else:
			$PromptDoor.hide()
		# Use Interactables
		if near_interactable and interactable != null:
			$PromptInteract.show()
			if Input.is_action_just_pressed("interact"):
				interactable.inspect()
		else:
			$PromptInteract.hide()
		
	prev_pos = global_position
	Globals.player_pos = position

func _on_area_2d_area_entered(area):
	if area.is_in_group("doors"):
		near_door = true
		door = area
	elif area.is_in_group("interactables"):
		near_interactable = true
		interactable = area

func _on_area_2d_area_exited(area):
	if area.is_in_group("doors"):
		near_door = false
		door = area
	elif area.is_in_group("interactables"):
		near_interactable = false
		interactable = area
