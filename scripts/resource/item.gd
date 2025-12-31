class_name Item extends Resource

@export var name: String
@export var icon: Texture2D
@export var mesh: PackedScene
@export var interactable: PackedScene = preload("res://scenes/utility/world_item.tscn")

@export_range(1,9) var stack_limit: int = 1
@export_range(1,9) var amount: int = 1
