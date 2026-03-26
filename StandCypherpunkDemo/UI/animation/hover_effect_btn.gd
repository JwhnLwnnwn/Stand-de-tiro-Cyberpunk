extends TextureButton

# Instâncias das cenas -> Redirect
@onready var tutorial_screen = preload("res://scenes/tutorial_scene.tscn");
var tutorial_instance = null

var border_top: ColorRect
var border_right: ColorRect
var border_bottom: ColorRect
var border_left: ColorRect

const BORDER_SIZE = 2
const BORDER_COLOR = Color("#E7089E")
const DURATION = 0.12

func _ready() -> void:
	await get_tree().process_frame
	_create_borders()

func _notification(what: int) -> void:
	match what:
		NOTIFICATION_MOUSE_ENTER:
			_on_hover_enter()
		NOTIFICATION_MOUSE_EXIT:
			_on_hover_exit()

func _create_borders() -> void:
	border_top   = _make_rect()
	border_right  = _make_rect()
	border_bottom = _make_rect()
	border_left   = _make_rect()
	add_child(border_top)
	add_child(border_right)
	add_child(border_bottom)
	add_child(border_left)
	_reset_borders()

func _make_rect() -> ColorRect:
	var r = ColorRect.new()
	r.color = BORDER_COLOR
	r.mouse_filter = Control.MOUSE_FILTER_IGNORE
	r.modulate.a = 0.0
	return r

func _reset_borders() -> void:
	var w = size.x
	var h = size.y

	border_top.size        = Vector2(0, BORDER_SIZE)
	border_top.position    = Vector2(0, 0)

	border_right.size      = Vector2(BORDER_SIZE, 0)
	border_right.position  = Vector2(w - BORDER_SIZE, 0)

	border_bottom.size     = Vector2(0, BORDER_SIZE)
	border_bottom.position = Vector2(w, h - BORDER_SIZE)

	border_left.size       = Vector2(BORDER_SIZE, 0)
	border_left.position   = Vector2(0, h)

	for border in [border_top, border_right, border_bottom, border_left]:
		border.modulate.a = 0.0

func _on_hover_enter() -> void:
	var w = size.x
	var h = size.y
	_reset_borders()

	var tween = create_tween()

	tween.tween_method(
		func(v: float): border_top.size.x = v,
		0.0, w, DURATION
	)
	tween.tween_method(
		func(v: float): border_right.size.y = v,
		0.0, h, DURATION
	)
	tween.tween_method(
		func(v: float):
			border_bottom.size.x = v
			border_bottom.position.x = w - v,
		0.0, w, DURATION
	)
	tween.tween_method(
		func(v: float):
			border_left.size.y = v
			border_left.position.y = h - v,
		0.0, h, DURATION
	)

	for border in [border_top, border_right, border_bottom, border_left]:
		border.modulate.a = 1.0

func _on_hover_exit() -> void:
	var tween = create_tween()
	for border in [border_top, border_right, border_bottom, border_left]:
		tween.parallel().tween_property(border, "modulate:a", 0.0, 0.15)
	await tween.finished
	_reset_borders()

# MARK: - Functions in btns
func _on_exit_btn_pressed() -> void:
	get_tree().quit();

func _on_tutorial_btn_pressed() -> void:
	if tutorial_instance == null:
		tutorial_instance = tutorial_screen.instantiate()
		get_tree().root.add_child(tutorial_instance)
	tutorial_instance.show_tutorial(tutorial_instance.Mode.MENU)
