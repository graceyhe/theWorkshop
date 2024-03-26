extends Node3D

var inventory = ""
var currItem = ""
var hoveredItem = ""
var disableMovement = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	#print("curritem: ", currItem)
	#print("inventory: ", inventory)
	if(Input.is_action_just_pressed("swipe")):
		if(currItem == "sword"):
			$PlayerBody/Camera/Inventory/sword/AnimationPlayer.play("swipe")
		if(currItem == "hammer"):
			$PlayerBody/Camera/Inventory/hammer/AnimationPlayer.play("HammerSwing")
			
	if Input.is_action_just_pressed("interact") && !disableMovement:
		print("pressed")
		$"../HUD/hudLayer/Full".hide()
		if(hoveredItem != ""):
			if(hoveredItem == "Furnace"):
				if(currItem != "" && inventory != "" && $"../inFurnace".occupied):
					$"../HUD/hudLayer/Full".show()
				else:
					var picked_up = $"../inFurnace".pickup()
					if(picked_up == "iron"):
						hoveredItem = "iron"
						attemptPickup()
					elif(picked_up == "blade"):
						hoveredItem = "blade"
						attemptPickup()
					if(currItem == "iron"):
						if($"../inFurnace".addIron()):
							currItem = ""
							$PlayerBody/Camera/Inventory.get_node("iron").hide()
			elif(hoveredItem == "Anvil"):				
				if(currItem != "" && inventory != "" && $"../onAnvil".occupied):
					$"../HUD/hudLayer/Full".show()
				else:
					if(currItem == "hammer" && $"../onAnvil".curr == "blade"):
						$".".disableMovement = true
						$"../onAnvil/Skillcheck".playing = true
						$"../onAnvil/Skillcheck/Control/CanvasLayer".show()
						$"../onAnvil/Skillcheck/Control/CanvasLayer/GridContainer".show()
						$"../HUD/hudLayer/InteractPrompt".text = "(E) Cancel"
					else:
						var picked_up = $"../onAnvil".pickup()
						if(picked_up == "blade"):
							hoveredItem = "blade"
							attemptPickup()
						elif(picked_up == "sword"):
							hoveredItem = "sword"
							attemptPickup()
						if(currItem == "blade"):
							if($"../onAnvil".addBlade()):
								currItem = inventory
								if(currItem != ""):
									$PlayerBody/Camera/Inventory.get_node(currItem).show()
								inventory = ""
								$PlayerBody/Camera/Inventory.get_node("blade").hide()
			else:
				attemptPickup()
	$"../HUD/hudLayer/Label".text = inventory
	
	if Input.is_action_just_pressed("drop") && !disableMovement:
		if(currItem != ""):
			$PlayerBody/Camera/Inventory.get_node(currItem).hide()
		currItem = ""
		
	
func _input(event):
	if event is InputEventMouseButton && event.is_pressed():
		# Check if the mouse wheel was scrolled up
		if !disableMovement && (event.button_index == MOUSE_BUTTON_WHEEL_UP || event.button_index == MOUSE_BUTTON_WHEEL_DOWN):
			var temp = inventory
			inventory = currItem
			currItem = temp
			if(inventory != ""):
				$PlayerBody/Camera/Inventory.get_node(inventory).hide()
			if(currItem != ""):
				$PlayerBody/Camera/Inventory.get_node(currItem).show()
			

func attemptPickup():
	if(inventory != "" && currItem != ""):
		$"../HUD/hudLayer/Full".show()
		print("inventory full")
	elif(currItem != ""):
		$PlayerBody/Camera/Inventory.get_node(currItem).hide()
		inventory = currItem
		currItem = hoveredItem
		$PlayerBody/Camera/Inventory.get_node(currItem).show()
	else:
		currItem = hoveredItem
		$PlayerBody/Camera/Inventory.get_node(currItem).show()
