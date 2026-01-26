extends Sprite2D

@export var available_textures: Array[Texture2D]

func _ready() -> void:
	texture = available_textures.pick_random()
