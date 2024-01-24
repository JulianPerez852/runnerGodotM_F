extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -600.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var sprite_animation = $AnimatedSprite2D/AnimationTree

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		print("esta en el aire")
	
	if is_on_floor():
		print("toco el suelo")
		sprite_animation["parameters/conditions/is_jumping"] = false
		sprite_animation["parameters/conditions/is_tochdown"] = true

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		sprite_animation["parameters/conditions/is_idle"] = false
		sprite_animation["parameters/conditions/is_moving"] = false
		sprite_animation["parameters/conditions/is_jumping"] = true
		
		print("SALTOOOO")

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
		sprite_animation["parameters/conditions/is_idle"] = false
		sprite_animation["parameters/conditions/is_moving"] = true
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		sprite_animation["parameters/conditions/is_idle"] = true
		sprite_animation["parameters/conditions/is_moving"] = false

	move_and_slide()
