extends Area2D

@export var weapon_data: WeaponData

var original_position: Vector2

func _ready():
	if weapon_data == null:
		return
	
	if not weapon_data.can_be_picked:
		queue_free()

func interact(player):
	if weapon_data == null:
		return
	
	player.weapon_manager.swap_weapon(self)
	
func _on_body_entered(body):
	if body.is_in_group("player"):
		body.set_interactable(self)

func _on_body_exited(body):
	if body.is_in_group("player"):
		body.clear_interactable(self)
