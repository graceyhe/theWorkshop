extends CharacterBody3D

# How fast the player moves in meters per second.
@export var speed = 14
# The downward acceleration when in the air, in meters per second squared.
@export var fall_acceleration = 75
# The upward velocity when jumping, in meters per second.
@export var jump_speed = 20
var disableMovement = false 
var target_velocity = Vector3.ZERO

func _physics_process(delta):
	disableMovement = $"..".disableMovement
	var direction = Vector3.ZERO
	var camera = $Camera
	var camera_transform = camera.global_transform
	var camera_basis = camera_transform.basis

	if Input.is_action_pressed("right"):
		direction += camera_basis.x.normalized()
	if Input.is_action_pressed("left"):
		direction -= camera_basis.x.normalized()
	if Input.is_action_pressed("down"):
		direction += camera_basis.z.normalized()
	if Input.is_action_pressed("up"):
		direction -= camera_basis.z.normalized()

	# Normalize direction vector if it's not zero
	if direction.length_squared() > 0:
		direction = direction.normalized()

	# Ground Velocity
	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed

	# Jump
	if is_on_floor() and Input.is_action_just_pressed("jump"):
		target_velocity.y = jump_speed

	# Apply gravity only when the character is in the air
	if not is_on_floor():
		target_velocity.y = target_velocity.y - (fall_acceleration * delta)

	# Moving the Character
	if (!disableMovement):
		velocity = target_velocity
	move_and_slide()
