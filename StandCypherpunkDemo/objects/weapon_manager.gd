extends Node

@onready var weapon = $Weapon

@export var default_weapon: WeaponData

var current_weapon: WeaponData

signal weapon_changed(data)
signal ammo_changed(current, max)
signal shot_fired

func _ready():
	if weapon == null:
		push_error("Weapon não encontrada!")
		return
	
	if default_weapon == null:
		push_error("Default weapon não configurada!")
		return
	
	if weapon.has_signal("ammo_changed"):
		weapon.ammo_changed.connect(_on_ammo_changed)
	
	current_weapon = default_weapon
	weapon.set_weapon(current_weapon)
	emit_signal("weapon_changed", current_weapon)
	emit_signal("ammo_changed", weapon.current_ammo, current_weapon.max_ammo)

func shoot(direction: Vector2):
	if weapon == null:
		return
	
	weapon.shoot(direction)
	
	emit_signal("shot_fired")

func set_weapon(new_weapon: WeaponData):
	if new_weapon == null:
		return
	
	current_weapon = new_weapon
	weapon.set_weapon(new_weapon)
	
	emit_signal("weapon_changed", new_weapon)
	emit_signal("ammo_changed", weapon.current_ammo, new_weapon.max_ammo)

func pickup_weapon(new_weapon: WeaponData):
	if new_weapon == null:
		return
	
	set_weapon(new_weapon)

func _on_ammo_changed(current, max):
	emit_signal("ammo_changed", current, max)
