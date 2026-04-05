extends CanvasLayer

@onready var weapon_icon = $WeaponIcon
@onready var ammo_label = $AmmoLabel
@onready var ammo_icon = $AmmoIcon

var weapon_manager

func _ready():
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
	# weapon_manager.shot_fired.connect(_on_shot_fired)
	
	_on_weapon_changed(weapon_manager.current_weapon)

func _on_weapon_changed(data):
	if data == null:
		return
	
	weapon_icon.texture = data.hud_sprite
	
	if data.infinite_ammo:
		ammo_label.hide()
		ammo_icon.show()
		ammo_icon.texture = data.ammo_icon
	else:
		ammo_label.show()
		ammo_icon.hide()

func _on_ammo_changed(current):
	if weapon_manager.current_weapon.infinite_ammo:
		return
	
	ammo_label.text = str(current)

#func _on_shot_fired():
	# chamar a animacao de HUD
