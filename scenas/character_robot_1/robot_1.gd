extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -600.0
enum state { idle, running, jumping, tochdown }

var current_state = state.idle
var already_play_animation = false
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var sprite_animation = $AnimatedSprite2D/AnimationPlayer
@onready var ray_cast = $RayCast2D

func _physics_process(delta):
	
	move(delta)
	move_and_slide()
	play_animations()

func move(delta):
	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		current_state = state.jumping
		return
		
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	var movement
	if direction:
		velocity.x = direction * SPEED
		movement = state.running
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		movement = state.idle
		
	fall(delta, movement)
		
func fall(delta, movement):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta
		if velocity.y > -10 and ray_cast.enabled ==false: 
			ray_cast.enabled = true
			
		if ray_cast.is_colliding():
			current_state = state.tochdown

	else:
		current_state = movement
		ray_cast.enabled = false

func play_animations():
	if current_state == state.idle:
		sprite_animation.play("idle")
	elif current_state == state.running:
		sprite_animation.play("running")
	elif current_state == state.jumping:
		if already_play_animation == false:
			sprite_animation.play("jumping")
			already_play_animation = true
	elif current_state == state.tochdown:
		if already_play_animation == true:
			sprite_animation.play("tochdown")
			already_play_animation = false
		
