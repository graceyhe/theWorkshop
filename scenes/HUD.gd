extends Node2D

@export var interactable = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func interactVisible(entered):
	if(entered):
		$hudLayer/InteractPrompt.show()
	else:
		$hudLayer/InteractPrompt.hide()
