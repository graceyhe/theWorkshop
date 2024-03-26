extends Node2D
var playing = false
var level = 0
var currPanel = 0
var order = [0, 0, 0, 0, 0]

var up = preload("res://assets/textures/up.png")
var down = preload("res://assets/textures/down.png")
var left = preload("res://assets/textures/left.png")
var right = preload("res://assets/textures/right.png")

# Called when the node enters the scene tree for the first time.
func _ready():
	for i in range(5):
		var random_number = randi() % 4 # Generate a random number between 0 and 4
		order[i] = random_number
		if(random_number == 0):
			$Control/CanvasLayer/GridContainer.get_child(i).get_child(0).set_texture(up)
		elif(random_number == 1):
			$Control/CanvasLayer/GridContainer.get_child(i).get_child(0).set_texture(down)
		elif(random_number == 2):
			$Control/CanvasLayer/GridContainer.get_child(i).get_child(0).set_texture(left)
		elif(random_number == 3):
			$Control/CanvasLayer/GridContainer.get_child(i).get_child(0).set_texture(right)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("cancel"):
		$"../../player".disableMovement = false
		playing = false
		$Control/CanvasLayer.hide()
	if playing && $"../../player".currItem == "hammer":
		var curr = order[currPanel]
		var correct = false
		if Input.is_action_just_pressed("up"):
			if(curr == 0):
				correct = true
				$Control/CanvasLayer/GridContainer.get_child(currPanel).hide()
			else:
				print("incorrect", curr)
		elif Input.is_action_just_pressed("down"):
			if(curr == 1):
				correct = true
				$Control/CanvasLayer/GridContainer.get_child(currPanel).hide()
			else:
				print("incorrect", curr)
		elif Input.is_action_just_pressed("left"):
			if(curr == 2):
				correct = true
				$Control/CanvasLayer/GridContainer.get_child(currPanel).hide()
			else:
				print("incorrect", curr)
		elif Input.is_action_just_pressed("right"):
			if(curr == 3):
				correct = true
				$Control/CanvasLayer/GridContainer.get_child(currPanel).hide()
			else:
				print("incorrect", curr)
		if correct:
			currPanel = currPanel + 1
			if(currPanel == 5):
				currPanel = 0
				level = level + 1
				$Control/CanvasLayer/GridContainer.hide()
				$"../../player/PlayerBody/Camera/Inventory/hammer/AnimationPlayer".play("HammerSwing")
				$Timer.start()
		correct = false

	
func startGame():
	$".".show()	

func _on_sparks_finished():
	for i in range(5):
		var random_number = randi() % 4 # Generate a random number between 0 and 4
		order[i] = random_number
		$Control/CanvasLayer/GridContainer.get_child(i).show()
		if(random_number == 0):
			$Control/CanvasLayer/GridContainer.get_child(i).get_child(0).set_texture(up)
		elif(random_number == 1):
			$Control/CanvasLayer/GridContainer.get_child(i).get_child(0).set_texture(down)
		elif(random_number == 2):
			$Control/CanvasLayer/GridContainer.get_child(i).get_child(0).set_texture(left)
		elif(random_number == 3):
			$Control/CanvasLayer/GridContainer.get_child(i).get_child(0).set_texture(right)
	if playing:
		$Control/CanvasLayer/GridContainer.show()
	if level == 3:
		level = 0
		playing = false
		$Control/CanvasLayer.hide()
		$"..".finishGame()
		$"../../player".disableMovement = false

func _on_timer_timeout():
	$"../../Sparks".emitting = true
