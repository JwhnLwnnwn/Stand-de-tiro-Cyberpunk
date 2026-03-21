extends CharacterBody2D

var PLAYER_VELOCITY: float = 200.0

@onready var muzzle: Marker2D = $Muzzle
@onready var shoot_part = $ShootPart

@export var bullet_scene: PackedScene
@export var fire_cooldown: float = 0.2

var current_weapon: WeaponData = null
var current_ammo: int = 0
var _is_moving: bool = false
var _can_shoot: bool = true
var _recoil_tween: Tween

func _physics_process(delta: float) -> void:
	_move(delta)
	_aim()
	_shoot()

func _move(delta: float) -> void:
	var dir = Vector2(
		Input.get_axis("move_left", "move_right"),
		Input.get_axis("move_up", "move_down")
	).normalized()

	var target_velocity = dir * PLAYER_VELOCITY
	
	velocity = lerp(velocity, target_velocity, 10 * delta)
	move_and_slide()

func _aim() -> void:
	var mouse_pos = get_global_mouse_position()
	var aim_direction: Vector2 = (mouse_pos - global_position).normalized()
	rotation = aim_direction.angle() + PI/2

func _shoot() -> void:
	if not _can_shoot:
		return
	if not Input.is_action_just_pressed("shoot"):
		return

	var bullet = bullet_scene.instantiate()
	bullet.global_position = shoot_part.global_position
	bullet.direction = (get_global_mouse_position() - global_position).normalized()
	get_parent().add_child(bullet)

	_can_shoot = false
	get_tree().create_timer(fire_cooldown).timeout.connect(func(): _can_shoot = true)

func _spawn_bullet() -> void:
	if bullet_scene == null:
		return
	var bullet = bullet_scene.instantiate()
	# Posição e rotação saem do Muzzle
	bullet.global_position = muzzle.global_position
	bullet.rotation = muzzle.global_rotation
	# Adiciona no pai para não herdar transformação do player
	get_parent().add_child(bullet)
