extends Node2D

@export var weapons: Array[WeaponData] = []
@export var pickup_scene: PackedScene
@onready var pickups_container: Node2D = $WeaponPickups

var spacing: float = 32.0

func _ready() -> void:
	if pickup_scene == null:
		push_error("Pickup Scene não foi configurada!")
		return

	for weapon_data in weapons:
		if weapon_data == null or not weapon_data.can_be_picked:
			continue

		_create_pickup(weapon_data)

	_rearrange_pickups()

func _create_pickup(weapon_data: WeaponData) -> void:
	var pickup = pickup_scene.instantiate()
	pickup.weapon_data = weapon_data
	pickup.bench = self
	pickups_container.add_child(pickup)

func return_weapon(weapon_data: WeaponData) -> void:
	if weapon_data == null or not weapon_data.can_be_picked:
		return

	_create_pickup(weapon_data)
	call_deferred("_rearrange_pickups")

func _rearrange_pickups() -> void:
	var pickups = pickups_container.get_children()
	var total := pickups.size()

	for i in range(total):
		pickups[i].position = Vector2(
			(i - (total - 1) / 2.0) * spacing,
			0
		)
