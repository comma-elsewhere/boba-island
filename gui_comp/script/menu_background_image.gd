extends TextureRect

@export var postcards: Array[Texture2D]

func _ready() -> void:
	texture = postcards.pick_random()
