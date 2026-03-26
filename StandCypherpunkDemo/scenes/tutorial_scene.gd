extends CanvasLayer

@onready var label = $back_btn/back_label
@onready var click_sfx = $SFX
var normal_tex = preload("res://UI/button/left_seta.png")
var pressed_tex = preload("res://UI/button/pressed_left_btn.png")
signal closed;

enum Mode {
	MENU,
	PAUSE
}

var current_mode = Mode.MENU

func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	visible = false
	print(label)
	print(label.texture)

func show_tutorial(mode) -> void:
	current_mode = mode
	visible = true
	
	for child in get_children():
		if child is CanvasItem:
			child.modulate.a = 0.0
	
	await get_tree().process_frame
	
	# O efeito de piscar apenas no sprite2D -> TODO: Alterar isso para funcionar nos containers (esperando os sprites)
	for child in get_children():
		if child is Sprite2D:
			await _blink_node(child)
	
	for child in get_children():
		if child is CanvasItem and not (child is Sprite2D):
			_fade_in(child)

func _blink_node(node: CanvasItem) -> void:
	var tween = create_tween()
	tween.set_loops(3)
	tween.tween_property(node, "modulate:a", 1.0, 0.15)
	tween.tween_property(node, "modulate:a", 0.0, 0.15)
	await tween.finished
	node.modulate.a = 1.0

func _fade_in(node: CanvasItem) -> void:
	var tween = create_tween()
	tween.tween_property(node, "modulate:a", 1.0, 0.5)


func _on_back_btn_pressed() -> void:
	label.texture = pressed_tex
	label.scale = Vector2(0.95, 0.95)

	click_sfx.play()

func _on_back_btn_button_up():
	await get_tree().create_timer(0.1).timeout
	label.texture = normal_tex
	label.texture = normal_tex
	var tween = create_tween()
	tween.tween_property(label, "scale", Vector2(1,1), 0.1)

# Essa tela de tutorial aparece tanto em MENU como PAUSE
	match current_mode:
		Mode.MENU:
			visible = false

		Mode.PAUSE:
			visible = false
	emit_signal("closed")
