extends CanvasLayer
@onready var weapon_icon = $Node2D/WeaponIcon
@onready var ammo_label = $Node2D/AmmoLabel
@onready var ammo_icon = $Node2D/AmmoIcon

@onready var prompt = $InteractionPrompt
@onready var label = $InteractionPrompt/Label
@onready var key_label = $InteractionPrompt/Key

var weapon_manager


func _ready() -> void:
	add_to_group("hud")
	hide_prompt()

	var player = get_tree().get_first_node_in_group("player")

	if player == null:
		push_error("Player não encontrado!")
		return

	weapon_manager = player.weapon_manager

	if weapon_manager == null:
		push_error("WeaponManager não encontrado!")
		return

	weapon_manager.weapon_changed.connect(_on_weapon_changed)
	weapon_manager.ammo_changed.connect(_on_ammo_changed)

	_on_weapon_changed(weapon_manager.current_weapon)

	_on_ammo_changed(
		weapon_manager.weapon.current_ammo,
		weapon_manager.current_weapon.max_ammo
	)


func show_prompt(message: String, key: String = "E") -> void:
	label.text = message
	prompt.show()


func hide_prompt() -> void:
	prompt.hide()


func _on_weapon_changed(data):
	if data == null:
		return

	weapon_icon.texture = data.hud_sprite

	ammo_icon.texture = data.ammo_icon
	ammo_icon.show()

	if data.infinite_ammo:
		ammo_label.hide()
	else:
		ammo_label.show()


func _on_ammo_changed(current, max):
	if weapon_manager.current_weapon == null:
		return

	if weapon_manager.current_weapon.infinite_ammo:
		return

	ammo_icon.texture = weapon_manager.current_weapon.ammo_icon
	ammo_label.text = str(current)
