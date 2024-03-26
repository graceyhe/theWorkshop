extends Camera3D

# Variables to control camera movement
var sensitivity = 0.3
var invertYAxis = false
var disableMovement = false
# Variables to store camera rotation
var cameraRotation = Vector2()

func _ready():
	# Hide the mouse cursor and grab focus
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	# Process mouse motion to rotate the camera
	if event is InputEventMouseMotion:
		var rotation_speed = sensitivity
		if invertYAxis:
			rotation_speed *= -1

		# Update camera rotation based on mouse movement
		cameraRotation.x -= rotation_speed * event.relative.y
		cameraRotation.y -= rotation_speed * event.relative.x

		# Clamp vertical rotation to avoid flipping
		cameraRotation.x = clamp(cameraRotation.x, -90, 90)

		# Rotate the camera
		rotation_degrees.x = cameraRotation.x
		rotation_degrees.y = cameraRotation.y
		
	if event is InputEventKey and event.is_action_pressed("pause"):
		# Toggle mouse mode between captured and free
		if Input.get_mouse_mode() == Input.MOUSE_MODE_CAPTURED:
			Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
		else:
			Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _process(delta):
	# Get the mouse position
	disableMovement = $"../..".disableMovement
	var mouse_pos = get_viewport().get_mouse_position()
	
	# Cast a ray from the camera's position into the scene
	var ray_from = project_ray_origin(mouse_pos)
	var ray_to = ray_from + project_ray_normal(mouse_pos) * 1000 # Adjust the length of the ray as needed
	
	# Perform the raycast
	var query = PhysicsRayQueryParameters3D.create(ray_from, ray_to)
	
	var space_state = get_world_3d().direct_space_state
	var result = space_state.intersect_ray(query)
	
	# Check if the ray intersected with anything
	if result && !disableMovement:
		# Get the object the ray intersected with
		var collider = result.collider
		var HUD = $"../../../HUD"
		var HUDLabel = $"../../../HUD/hudLayer/InteractPrompt"
		var player = $"../.."
		var currWeapon = player.currItem
		match collider.get_parent().name:
			"Anvil":
				$"../..".hoveredItem = ""
				if "blade" == currWeapon && !$"../../../onAnvil".occupied:
					HUD.interactVisible(true)
					HUDLabel.text = "(F) Place blade on Anvil"
					$"../..".hoveredItem = "Anvil"
				if $"../../../onAnvil".curr == "sword":
					HUD.interactVisible(true)
					HUDLabel.text = "(F) Pick up sword"
					$"../..".hoveredItem = "Anvil"
				if $"../../../onAnvil".curr == "blade" && "hammer" == currWeapon:
					HUD.interactVisible(true)
					HUDLabel.text = "(F) Start/Continue forging"
					$"../..".hoveredItem = "Anvil"
			"blade":
				HUD.interactVisible(true)
				HUDLabel.text = "(F) Pick up blade"
				$"../..".hoveredItem = "blade"
			"Hammer":
				HUD.interactVisible(true)
				HUDLabel.text = "(F) Pick up hammer"
				$"../..".hoveredItem = "hammer"
			"Furnace":
				$"../..".hoveredItem = "Furnace"
				if $"../..".currItem == "iron":
					HUD.interactVisible(true)
					HUDLabel.text = "(F) Process iron"
				if $"../../../inFurnace".curr == "blade":
					HUD.interactVisible(true)
					HUDLabel.text = "(F) Pick up blade"
			_:
				if(collider.get_parent().name.substr(0, 8) == "Cylinder"):
					HUD.interactVisible(true)
					HUDLabel.text = "(F) Pick up iron"
					$"../..".hoveredItem = "iron"
				else:
					HUD.interactVisible(false)
					$"../..".hoveredItem = ""
