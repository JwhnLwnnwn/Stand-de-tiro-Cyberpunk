extends CharacterBody2D

var hp: int = 4

func take_damage(amount: int):
	hp -= amount
	if hp <= 0:
		die()

func die():
	queue_free()
