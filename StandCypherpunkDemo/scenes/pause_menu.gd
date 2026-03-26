extends CanvasLayer

var tutorial_scene = preload("res://scenes/tutorial_scene.tscn")
var menu_scene = preload("res://scenes/menu.tscn");
var tutorial_instance = null
var tutorial_aberto = false

func _ready() -> void:
	visible = false
	get_tree().paused = false

func _unhandled_input(event: InputEvent) -> void:
	if tutorial_aberto:
		return
	if event.is_action_pressed("ui_cancel"):
		visible = true
		get_tree().paused = true

func _on_resume_btn_pressed() -> void:
	get_tree().paused = false
	visible = false

func _on_tutorial_btn_pressed() -> void:
	tutorial_aberto = true
	visible = false

	if tutorial_instance == null:
		tutorial_instance = tutorial_scene.instantiate()
		get_tree().root.add_child(tutorial_instance)
		tutorial_instance.closed.connect(_on_tutorial_closed)
	tutorial_instance.show_tutorial(tutorial_instance.Mode.PAUSE)
	
func _on_tutorial_closed():
	tutorial_aberto = false
	visible = true

func _on_menu_btn_pressed() -> void:
	visible = false
	await JohnPixelTransition.play_transition("res://scenes/menu.tscn")
