extends Node2D
var simulation_active := false
var can_toggle := true

func _ready() -> void:
	updateStatusEnemies(false)

func _process(delta: float) -> void:
	pass
	
func updateStatusEnemies(active: bool) -> void:
	for enemy in get_tree().get_nodes_in_group("enemies"):
		enemy.visible = active
		
		if enemy.has_node("CollisionShape2D"):
			enemy.get_node("CollisionShape2D").disabled = !active

func startSimulation():
	simulation_active = true
	updateStatusEnemies(true)

func stopSimulation():
	simulation_active = false
	updateStatusEnemies(false)
