class_name Seed extends Item

@export var crop_data: Crop
@export var crop_scene: PackedScene = preload("res://scenes/utility/crop.tscn")


func am_seed() -> bool:
	return true
