
extends Area2D

var direction: Vector2 = Vector2.ZERO
var _traveled: float = 0.0

# arma data
var speed: float = 0.0
var damage: float = 0.0
var piercing: bool = false
var max_range: float = 0.0
var explosive: bool = false
var explosion_radius: float = 0.0

# colisao
var has_hit: bool = false
var _exploded: bool = false
var hit_targets: Array[Node] = []

func setup(dir: Vector2, weapon_data: WeaponData) -> void:
	direction = dir.normalized()
	rotation = direction.angle()

	speed = weapon_data.bullet_speed
	damage = weapon_data.damage
	piercing = weapon_data.piercing
	max_range = weapon_data.bullet_range
	explosive = weapon_data.explosive
	explosion_radius = weapon_data.explosion_radius

	_traveled = 0.0
	has_hit = false
	_exploded = false
	hit_targets.clear()

func _physics_process(delta: float) -> void:
	if direction == Vector2.ZERO:
		return

	var step := direction * speed * delta

	global_position += step
	_traveled += step.length()

	if _traveled >= max_range:
		_die()

func set_direction(new_direction: Vector2) -> void:
	direction = new_direction.normalized()
	rotation = direction.angle()

func _on_body_entered(body: Node2D) -> void:
	if _exploded or not body.is_in_group("enemy"):
		return

	if body in hit_targets:
		return

	hit_targets.append(body)
	has_hit = true

	if explosive:
		_explode()
		return

	_apply_damage(body, direction * 250.0)

	if not piercing:
		queue_free()

func _apply_damage(body: Node2D, knockback: Vector2) -> void:
	if not is_instance_valid(body):
		return

	if body.has_method("take_damage"):
		body.take_damage(damage)

	if body.has_method("apply_knockback"):
		body.apply_knockback(knockback)

func _explode() -> void:
	if _exploded:
		return

	_exploded = true

	if explosion_radius <= 0.0:
		queue_free()
		return

	var space := get_world_2d().direct_space_state

	var shape := CircleShape2D.new()
	shape.radius = explosion_radius

	var query := PhysicsShapeQueryParameters2D.new()
	query.shape = shape
	query.transform = Transform2D(0.0, global_position)
	query.collision_mask = collision_mask
	query.collide_with_bodies = true
	query.collide_with_areas = false

	var results := space.intersect_shape(query)

	var explosion_targets: Array[Node] = []

	for result in results:
		var body = result.collider

		if not body is Node2D:
			continue

		if not body.is_in_group("enemy"):
			continue

		if body in explosion_targets:
			continue

		explosion_targets.append(body)

		var knockback_direction: Vector2 = (
			body.global_position - global_position
		).normalized()

		if knockback_direction == Vector2.ZERO:
			knockback_direction = direction

		_apply_damage(body, knockback_direction * 600.0)

	queue_free()
	
func _die() -> void:
	if not is_inside_tree():
		return

	if explosive:
		_explode()
	else:
		queue_free()


func _on_screen_notifier_screen_exited() -> void:
	queue_free()
