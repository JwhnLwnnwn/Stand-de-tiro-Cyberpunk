extends CharacterBody2D

@export var speed: float = 20.0
var direction: int = 1
var hp: int = 2

@onready var ray: RayCast2D = $RayCast2D

var flip_timer: float = 0.0
var flip_delay: float = 1.0

func _ready():
	if ray:
		ray.target_position.x = abs(ray.target_position.x) * direction

func _physics_process(delta: float) -> void:
	_move(delta)

func _move(delta: float) -> void:
	velocity.x = speed * direction

	if ray and not ray.is_colliding():
		flip_timer += delta
		if flip_timer >= flip_delay:
			flip_direction()
			flip_timer = 0.0
	else:
		flip_timer = 0.0

	move_and_slide()

func flip_direction():
	direction *= -1
	if ray:
		ray.target_position.x = abs(ray.target_position.x) * direction

func take_damage(amount: int):
	hp -= amount
	if hp <= 0:
		die()

func die():
	queue_free()
