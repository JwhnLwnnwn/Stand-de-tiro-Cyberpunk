extends TextureButton

@onready var tutorial_screen = preload("res://scenes/tutorial_scene.tscn")
var tutorial_instance = null

const BORDER_SIZE := 2
const BORDER_COLOR := Color("#E7089E")
const DURATION := 0.12

var borders: Array[ColorRect] = []

func _ready() -> void:
	await get_tree().process_frame
	_create_borders()

func _notification(what: int) -> void:
	if what == NOTIFICATION_MOUSE_ENTER:
		_on_hover_enter()
	elif what == NOTIFICATION_MOUSE_EXIT:
		_on_hover_exit()

# Border effect -> Figma
func _create_borders() -> void:
	for i in 4:
		var rect := ColorRect.new()
		rect.color = BORDER_COLOR
		rect.mouse_filter = Control.MOUSE_FILTER_IGNORE
		rect.modulate.a = 0.0
		add_child(rect)
		borders.append(rect)

	_reset_borders()

func _reset_borders() -> void:
	var w := size.x
	var h := size.y

	# top
	borders[0].size = Vector2(0, BORDER_SIZE)
	borders[0].position = Vector2.ZERO

	# right
	borders[1].size = Vector2(BORDER_SIZE, 0)
	borders[1].position = Vector2(w - BORDER_SIZE, 0)

	# bottom
	borders[2].size = Vector2(0, BORDER_SIZE)
	borders[2].position = Vector2(w, h - BORDER_SIZE)

	# left
	borders[3].size = Vector2(BORDER_SIZE, 0)
	borders[3].position = Vector2(0, h)

	for b in borders:
		b.modulate.a = 0.0

func _on_hover_enter() -> void:
	_reset_borders()

	var w := size.x
	var h := size.y
	var tween := create_tween()

	# top
	tween.tween_method(func(v): borders[0].size.x = v, 0.0, w, DURATION)

	# right
	tween.parallel().tween_method(func(v): borders[1].size.y = v, 0.0, h, DURATION)

	# bottom
	tween.parallel().tween_method(func(v):
		borders[2].size.x = v
		borders[2].position.x = w - v
	, 0.0, w, DURATION)

	# left
	tween.parallel().tween_method(func(v):
		borders[3].size.y = v
		borders[3].position.y = h - v
	, 0.0, h, DURATION)

	for b in borders:
		b.modulate.a = 1.0

func _on_hover_exit() -> void:
	var tween := create_tween()

	for b in borders:
		tween.parallel().tween_property(b, "modulate:a", 0.0, 0.15)

	await tween.finished
	_reset_borders()

# MARK: - Functions in btns menu
func _on_exit_btn_pressed() -> void:
	get_tree().quit()

func _on_tutorial_btn_pressed() -> void:
	if tutorial_instance == null:
		tutorial_instance = tutorial_screen.instantiate()
		get_tree().root.add_child(tutorial_instance)

	tutorial_instance.show_tutorial(tutorial_instance.Mode.MENU)

func on_start_btn_pressed() -> void:
	await JohnPixelTransition.play_transition("res://scenes/gameplay.tscn")
