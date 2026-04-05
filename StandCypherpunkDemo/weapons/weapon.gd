class_name Weapon
extends Node2D

@export var data: WeaponData
@onready var muzzle = $Muzzle
@onready var melee_hitbox = $MeleeHitbox

@onready var sprite = $Sprite2D
var current_ammo: int
var can_shoot: bool = true
signal ammo_changed(current, max)

func _ready():
	_apply_data();
		
func set_weapon(new_data: WeaponData):
	data = new_data
	_apply_data()

func _apply_data():
	if data == null:
		return
	
	current_ammo = data.max_ammo
	emit_signal("ammo_changed", current_ammo, data.max_ammo)
	
	if data.weapon_sprite:
		sprite.texture = data.weapon_sprite

func shoot(direction: Vector2):
	if not can_shoot:
		return
	
	rotation = direction.angle()
	can_shoot = false

	if data.bullet_scene == null:
		_melee_attack()
	else:
		if current_ammo <= 0:
			return
		
		current_ammo -= 1
		emit_signal("ammo_changed", current_ammo, data.max_ammo)
		_spawn_bullets(direction)

	await get_tree().create_timer(data.fire_cooldown).timeout
	can_shoot = true
	
func _melee_attack():
	melee_hitbox.monitoring = true
	await get_tree().create_timer(0.1).timeout
	melee_hitbox.monitoring = false

func _spawn_bullets(direction: Vector2):
	for i in range(data.pellets):
		var spread = randf_range(-data.spread, data.spread)
		var final_dir = direction.rotated(spread).normalized()
		
		if data.bullet_scene:
			var bullet = data.bullet_scene.instantiate()
			bullet.global_position = muzzle.global_position
			bullet.setup(final_dir, data)
			get_tree().current_scene.add_child(bullet)
		else:
			_spawn_hand_attack(final_dir)
			
func _spawn_hand_attack(direction: Vector2):
	var area = Area2D.new()
	var shape = CircleShape2D.new()
	shape.radius = 10
	var collision = CollisionShape2D.new()
	collision.shape = shape
	area.add_child(collision)
	area.global_position = muzzle.global_position
	
	area.connect("body_entered", Callable(self, "_on_meele_hitbox_area_entered"))
	
	get_tree().current_scene.add_child(area)
	
	area.queue_free()

func _on_meele_hitbox_area_entered(body) -> void:
	if body.is_in_group("enemies"):
		body.take_damage(data.damage)
