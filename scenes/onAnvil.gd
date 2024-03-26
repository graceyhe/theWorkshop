extends Node3D

var curr = ""
var occupied = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func addBlade():
	if(occupied):
		if(curr == "blade"):
			$Skillcheck.playing = true
			$Skillcheck/Control/CanvasLayer.show()
		return false
	if(curr == ""):
		print("added blade")
		curr = "blade"
		occupied = true
		$blade.show()
		return true
	else:
		return false

func pickup():
	print("picked up" + curr)
	if(curr != ""):
		occupied = false
	$blade.hide()
	$sword.hide()
	var to_pick = curr
	curr = ""
	return to_pick

func finishGame():
	if(curr == "blade"):
		curr = "sword"
		$sword.show()
		$blade.hide()
	

