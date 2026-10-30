extends CharacterBody2D

var PLAYER_VELOCITY: float = 200.0

@onready var weapon_manager = $WeaponManager
@onready var hud = get_tree().get_first_node_in_group("hud")

var current_interactable = null

func _physics_process(delta: float) -> void:
	_move(delta)
	_aim()
	_handle_shoot()

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("interact"):
		if current_interactable != null and is_instance_valid(current_interactable):
			if current_interactable.has_method("interact"):
				current_interactable.interact(self)

				# Atualiza o texto após a interação
				if is_instance_valid(current_interactable):
					set_interactable(current_interactable)


func set_interactable(obj):
	current_interactable = obj

	var hud = get_tree().get_first_node_in_group("hud")

	if hud:
		hud.show_prompt("pegar arma")

func clear_interactable(obj):
	if current_interactable == obj:
		current_interactable = null

	if hud:
		hud.hide_prompt()

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

	rotation = aim_direction.angle() + PI / 2

func _handle_shoot() -> void:
	var direction = (get_global_mouse_position() - global_position).normalized()

	if Input.is_action_pressed("shoot"):
		weapon_manager.shoot(direction)
