extends Node

const FONT_PATH := "res://UI/fontes/Pixeteam.ttf"

func _ready():
	var theme := Theme.new()

	# =========================
	# 🔤 FONTE
	# =========================
	if ResourceLoader.exists(FONT_PATH):
		var font = load(FONT_PATH)
		theme.set_font("font", "Button", font)
		theme.set_font_size("font_size", "Button", 16)

	# =========================
	# 🌈 CORES DO TEXTO
	# =========================
	theme.set_color("font_color", "Button", Color("EB118A"))
	theme.set_color("font_hover_color", "Button", Color(0.8, 0.1, 0.5))
	theme.set_color("font_pressed_color", "Button", Color(0.602, 0.043, 0.369, 1.0))

	# =========================
	# 🌫️ DROP SHADOW (FIGMA STYLE)
	# =========================
	var shadow_color := Color(0.012, 0.718, 0.729, 1.0)

	# Aplica tanto em Button quanto Label (garante funcionamento)
	for type in ["Button", "Label"]:
		theme.set_color("font_shadow_color", type, shadow_color)
		theme.set_constant("shadow_offset_x", type, 0)
		theme.set_constant("shadow_offset_y", type, 6)
		theme.set_constant("font_shadow_outline_size", type, 2)

	# =========================
	# 🎯 APLICAR GLOBALMENTE
	# =========================
	get_tree().root.theme = theme
