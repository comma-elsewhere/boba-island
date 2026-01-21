class_name Seed extends Item

@export var crop_data: Crop
@export var crop_scene: PackedScene = preload("res://scenes/utility/crop.tscn")
@export_range(0.5, 3.0, 0.5) var price_mod: float = 1.0

func am_seed() -> bool:
	return true

func buy_seed() -> bool:
	var price = float(Dynamic.seed_cost) * price_mod
	if Dynamic.total_money >= price:
		Dynamic.total_money -= int(price)
		return true
	else:
		return false
