extends CharacterBody2D

var direction: Vector2
var speed: float
var range: float
var damage: int
var distance_traveled: float = 0

func setup(dir: Vector2, weapon_data: WeaponData):
	direction = dir.normalized()
	speed = weapon_data.bullet_speed
	range = weapon_data.bullet_range
	damage = weapon_data.damage

func _physics_process(delta):
	var movement = direction * speed * delta
	velocity = movement
	move_and_collide(movement)

	distance_traveled += movement.length()

	if distance_traveled >= range:
		queue_free()
