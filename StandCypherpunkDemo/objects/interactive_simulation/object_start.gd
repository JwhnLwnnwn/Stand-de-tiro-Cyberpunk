extends Area2D

var player_inside := false

func _ready():
	pass
	
func _on_body_entered(body):
	if body.is_in_group("player"):
		body.current_interactable = self

func _on_body_exited(body):
	if body.is_in_group("player"):
		body.current_interactable = null

func interact():
	var gameplay = get_tree().get_first_node_in_group("gameplay")

	if gameplay.simulation_active:
		gameplay.stopSimulation()
	else:
		gameplay.startSimulation()
