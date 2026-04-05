extends Area2D

var direction: Vector2 = Vector2.ZERO
var _traveled: float = 0.0

# usa o weapons_data
var speed: float
var damage: int
var piercing: bool
var max_range: float
var explosive: bool
var explosion_radius: float

var has_hit := false

func setup(dir: Vector2, weapon_data):
	direction = dir.normalized()
	rotation = direction.angle()
	
	speed = weapon_data.bullet_speed
	damage = weapon_data.damage
	piercing = weapon_data.piercing
	max_range = weapon_data.bullet_range
	explosive = weapon_data.explosivea
	explosion_radius = weapon_data.explosion_radius

func _physics_process(delta: float) -> void:
	var step = direction * speed * delta
	position += step
	
	_traveled += step.length()
	if _traveled >= max_range:
		_die()

func set_direction(new_direction: Vector2) -> void:
	direction = new_direction.normalized()

func _on_body_entered(body: Node) -> void:
	if not body.is_in_group("enemy"):
		return
	
	body.take_damage(damage)
	
	if body.has_method("apply_knockback"):
		body.apply_knockback(direction * 250.0)
	
	if explosive:
		_explode()
	elif not piercing:
		queue_free()
		
func _explode() -> void:
	var space = get_world_2d().direct_space_state
	var query = PhysicsShapeQueryParameters2D.new()
	var shape = CircleShape2D.new()
	shape.radius = explosion_radius
	
	query.shape = shape
	query.transform = Transform2D(0, global_position)
	var results = space.intersect_shape(query)
	var hit_bodies := []

	for r in results:
		var body = r.collider
		if body in hit_bodies:
			continue
		hit_bodies.append(body)

		if body.is_in_group("enemy"):
			body.take_damage(damage)

			if body.has_method("apply_knockback"):
				var dir = (body.global_position - global_position).normalized()
				body.apply_knockback(dir * 600.0)
	queue_free()

func _die() -> void:
	if explosive:
		_explode()
	else:
		queue_free()

func _on_screen_notifier_screen_exited():
	queue_free()
