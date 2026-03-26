extends CharacterBody2D

var player: Node2D = null
@onready var sprite = $Sprite2D
var hp: int = 6

func _ready():
	player = get_tree().current_scene.get_node("Player")

func _process(delta):
	if not player:
		return

	var direction: Vector2 = (player.global_position - global_position).normalized()
	rotation = direction.angle() - PI/2

func take_damage(amount: int):
	hp -= amount
	if hp <= 0:
		die()

func die():
	queue_free()
