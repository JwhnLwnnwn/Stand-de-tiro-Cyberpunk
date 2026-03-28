extends CanvasLayer

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var frame_time: float = 0.05
var _transitioning: bool = false

func _ready():
	sprite.visible = false
	sprite.frame = 0
	process_mode = Node.PROCESS_MODE_ALWAYS

func play_transition(scene_path: String) -> void:
	if _transitioning:
		return
	if not ResourceLoader.exists(scene_path):
		push_error("Cena não encontrada: " + scene_path)
		return
	_transitioning = true
	sprite.visible = true
	await _animate_out()
	get_tree().change_scene_to_file(scene_path)
	await get_tree().process_frame
	await _animate_in()
	_finish()

func _finish() -> void:
	sprite.visible = false
	_transitioning = false
	get_tree().paused = false

func _animate_out() -> void:
	var anim := sprite.animation
	var total := sprite.sprite_frames.get_frame_count(anim)
	for i in range(total):
		sprite.frame = i
		await get_tree().create_timer(frame_time).timeout

func _animate_in() -> void:
	var anim := sprite.animation
	var total := sprite.sprite_frames.get_frame_count(anim)
	for i in range(total - 1, -1, -1):
		sprite.frame = i
		await get_tree().create_timer(frame_time).timeout
