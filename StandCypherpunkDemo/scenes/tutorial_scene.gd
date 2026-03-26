extends CanvasLayer

@onready var control = $Control
@onready var bg = $Control/Background
@onready var icon = $Control/back_btn/back_label
@onready var click_sfx = $SFX

var normal_tex = preload("res://UI/button/left_seta.png")
var pressed_tex = preload("res://UI/button/pressed_left_btn.png")

var tut_gray_tex = preload("res://UI/tutorial/tutorial_gray.png")
var tut_neon_tex = preload("res://UI/tutorial/tutorial_neon.png")
var tut_final_tex = preload("res://UI/tutorial/tela_tutorial.png")

signal closed

enum Mode {
	MENU,
	PAUSE
}

var current_mode = Mode.MENU

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	visible = false

func show_tutorial(mode) -> void:
	current_mode = mode
	visible = true
	
	for child in control.get_children():
		if child is CanvasItem and child != bg:
			child.modulate.a = 0.0
	
	await get_tree().process_frame
	
	await _blink_background()
	
	for child in control.get_children():
		if child is CanvasItem and child != bg:
			_fade_in(child)

func _blink_background() -> void:
	var times = 4
	
	for i in range(times):
		bg.texture = tut_gray_tex
		await get_tree().create_timer(0.08).timeout
		
		bg.texture = tut_neon_tex
		await get_tree().create_timer(0.08).timeout
	
	bg.texture = tut_final_tex

func _fade_in(node: CanvasItem) -> void:
	var tween = create_tween()
	tween.tween_property(node, "modulate:a", 1.0, 0.3)

func _on_back_btn_pressed() -> void:
	icon.pivot_offset = icon.size / 2
	
	icon.texture = pressed_tex
	icon.scale = Vector2(0.95, 0.95)
	
	click_sfx.play()

func _on_back_btn_button_up() -> void:
	await get_tree().create_timer(0.1).timeout
	
	icon.texture = normal_tex
	
	var tween = create_tween()
	tween.tween_property(icon, "scale", Vector2(1, 1), 0.1)

	_close()

func _close() -> void:
	visible = false
	emit_signal("closed")
