extends Node3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_iron_mouse_entered():
	$"../HUD".interactVisible(true)
	

func _on_iron_mouse_exited():
	$"../HUD".interactVisible(false)
