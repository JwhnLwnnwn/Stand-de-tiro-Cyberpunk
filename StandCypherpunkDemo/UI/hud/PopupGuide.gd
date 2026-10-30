extends Control

@onready var key_icon: TextureRect = $Key
@onready var action_label: Label = $Label

@export var key_e: Texture2D
@export var key_r: Texture2D
@export var key_f: Texture2D

func show_prompt(action: String, key: String):
	action_label.text = action

	match key:
		"E":
			key_icon.texture = key_e
		"R":
			key_icon.texture = key_r
		"F":
			key_icon.texture = key_f

	visible = true

func hide_prompt():
	visible = false
