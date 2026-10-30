extends Area2D

@export var weapon_data: WeaponData
var bench: Node2D

@onready var sprite: Sprite2D = $Sprite2D

func _ready() -> void:
	if weapon_data == null:
		push_warning("WeaponData não configurado!")
		return

	if not weapon_data.can_be_picked:
		queue_free()
		return

	sprite.texture = weapon_data.weapon_sprite

func interact(player: Node) -> void:
	if weapon_data == null or not is_instance_valid(player):
		return

	if player.weapon_manager == null:
		return

	var manager = player.weapon_manager

	if manager.current_weapon == weapon_data:
		return

	var previous_weapon: WeaponData = manager.current_weapon

	if previous_weapon != null and previous_weapon.can_be_picked:
		if is_instance_valid(bench):
			bench.return_weapon(previous_weapon)

	manager.pickup_weapon(weapon_data)
	queue_free()

func get_interaction_text() -> String:
	if weapon_data == null:
		return "Pegar arma"

	return "Pegar " + weapon_data.weapon_name

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.set_interactable(self)

func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.clear_interactable(self)
