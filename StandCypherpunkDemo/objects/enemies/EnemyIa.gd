extends CharacterBody2D

enum State { IDLE, ALERT, SHOOTING, DEAD }

@export var detection_range := 300.0
@export var shoot_range := 250.0
@export var shoot_cooldown := 1.5
@export var bullet_scene : PackedScene

var state = State.IDLE
var player : Node2D
var shoot_timer := 0.0

func _ready():
	player = get_tree().get_first_node_in_group("player")

func _physics_process(delta):
	match state:
		State.IDLE:    _idle()
		State.ALERT:   _alert()
		State.SHOOTING: _shooting(delta)

func _idle():
	if player == null: return
	var dist = global_position.distance_to(player.global_position)
	if dist < detection_range and _has_line_of_sight():
		state = State.ALERT

func _alert():
	if player == null: return
	var dist = global_position.distance_to(player.global_position)
	
	# Vira para o jogador
	look_at(player.global_position)
	
	if dist < shoot_range:
		state = State.SHOOTING
	elif dist > detection_range:
		state = State.IDLE

func _shooting(delta):
	if player == null: return
	
	look_at(player.global_position)
	shoot_timer -= delta
	
	if shoot_timer <= 0.0:
		_shoot()
		shoot_timer = shoot_cooldown
	
	# Sai do estado se jogador fugiu
	var dist = global_position.distance_to(player.global_position)
	if dist > shoot_range or not _has_line_of_sight():
		state = State.ALERT

func _shoot():
	if bullet_scene == null: return
	var bullet = bullet_scene.instantiate()
	bullet.global_position = global_position
	bullet.rotation = rotation
	get_parent().add_child(bullet)

func _has_line_of_sight() -> bool:
	var space = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(
		global_position,
		player.global_position,
		0b11  # collision mask
	)
	query.exclude = [self]
	var result = space.intersect_ray(query)
	
	# Só há linha de visão se o raio bater no jogador
	return result.has("collider") and result["collider"] == player

func take_damage():
	state = State.DEAD
	# Animação de morte, desabilitar colisão, etc.
	queue_free()
