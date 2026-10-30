class_name Door
extends Area2D

var opened := false
var animating := false

const OPEN_ROTATION := -90.0
const ANIMATION_DURATION := 0.4

@onready var hinge: Node2D = $Hinge
@onready var interaction_shape: CollisionShape2D = $InteractionShape
@onready var solid_collision: CollisionShape2D = $Hinge/StaticBody2D/CollisionShape2D

# note: do jeito que esta a estrutura de nós, a colisao 2d que está fora dos filhos (pra que a Area2D seja interagivel) precisa desse script pra acompanhar o objeto da porta quando a animacao é ativada, movendo tambem a colisao para encaixar com o objeto.
func _process(_delta: float) -> void:
	interaction_shape.global_transform = hinge.global_transform * Transform2D(
		0.0,
		Vector2(0, 24)
	)

func interact(_player: Node = null) -> void:
	if animating:
		return

	opened = !opened
	animating = true

	var target_rotation := OPEN_ROTATION if opened else 0.0

	if opened:
		solid_collision.set_deferred("disabled", true)

	var tween := create_tween()
	tween.set_trans(Tween.TRANS_SINE)
	tween.set_ease(Tween.EASE_IN_OUT)

	tween.tween_property(
		hinge,
		"rotation_degrees",
		target_rotation,
		ANIMATION_DURATION
	)

	tween.finished.connect(_on_animation_finished)


func _on_animation_finished() -> void:
	if not opened:
		solid_collision.set_deferred("disabled", false)

	animating = false


func get_interaction_text() -> String:
	return "Fechar" if opened else "Abrir"


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.set_interactable(self)


func _on_body_exited(body: Node2D) -> void:
	if body.is_in_group("player"):
		body.clear_interactable(self)
