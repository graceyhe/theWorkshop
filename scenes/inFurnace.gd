extends Node3D

var occupied = false
var curr = ""
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func addIron():
	if(occupied):
		return false
	if(curr == ""):
		print("added iron")
		curr = "iron"
		occupied = true
		$iron.show()
		$Timer.start()
		return true
	else:
		return false

func pickup():
	print("picked up" + curr)
	occupied = false
	var to_pick = curr
	curr = ""
	$blade.hide()
	$iron.hide()
	return to_pick

func _on_timer_timeout():
	if(curr == "iron"):
		curr = "blade"
		$blade.show()
		$iron.hide()
	
