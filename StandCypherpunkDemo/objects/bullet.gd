extends Area2D

@export var speed: float = 900.0
@export var damage: int = 1
@export var piercing: bool = false
@export var max_range: float = 600.0
@export var explosive: bool = false
@export var explosion_radius: float = 0.0

var direction: Vector2 = Vector2.ZERO
var _traveled: float = 0.0

func _physics_process(delta: float) -> void:
	var step = direction.rotated(rotation) * speed * delta
	position += step
	_traveled += step.length()
	if _traveled >= max_range:
		_die()

func set_direction(new_direction: Vector2) -> void:
	direction = new_direction.normalized()

func _on_body_entered(body: Node) -> void:
	if body.is_in_group("enemy"):
		body.take_damage(damage)
		if body.has_method("apply_knockback"):
			body.apply_knockback(direction.rotated(rotation) * 250.0)
	if explosive:
		_explode()
	elif not piercing:
		queue_free()

func _explode() -> void:
	# Dano em área
	var space = get_world_2d().direct_space_state
	var query = PhysicsShapeQueryParameters2D.new()
	var shape = CircleShape2D.new()
	shape.radius = explosion_radius
	query.shape = shape
	query.transform = Transform2D(0, global_position)
	#query.collision_mask = 0b10  # layer dos inimigos — ajuste conforme seu projeto
	var results = space.intersect_shape(query)
	for r in results:
		var body = r.collider
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
