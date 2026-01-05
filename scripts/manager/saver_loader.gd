class_name SaverLoader extends Node
@export var world_root: Node3D
@export var player: Player

func save_game() -> void:
	var saved_game: SavedGame = SavedGame.new()
	
	saved_game.player_position = player.global_position
	saved_game.player_inventory = player.hud.hotbar_array
	saved_game.financial_variables = _get_finances()
	saved_game.upgrade_variables = _get_upgrades()
	saved_game.diff_danger_variables = _get_diff_danger()
	world_root.call_group("GameEvent", "on_save_game", saved_game.saved_data)
	
	ResourceSaver.save(saved_game, "user://savedata.res")
	
func load_game() -> void:
	var saved_game = load("user://savedata.res")
	
	world_root.call_group("GameEvent","on_preload")
	
	for item in saved_game.saved_data:
		var load_item = load(item.scene_file_path) as PackedScene
		var instantiate_item = load_item.instantiate()
		world_root.add_child(instantiate_item)
		instantiate_item.on_load(item)

func _get_finances() -> Array:
	var finance_array: Array = []
	finance_array.append(Dynamic.total_money)
	finance_array.append(Dynamic.total_debt)
	finance_array.append(Dynamic.today_earned)
	finance_array.append(Dynamic.orders_filled)
	finance_array.append(Dynamic.tips_earned)
	finance_array.append(Dynamic.misc_earned)
	finance_array.append(Dynamic.upgrade_spent)
	finance_array.append(Dynamic.seed_spent)
	return finance_array
	
func _get_upgrades() -> Array:
	var upgrade_array: Array = []
	upgrade_array.append(Dynamic.inventory_space)
	upgrade_array.append(Dynamic.moisture_loss)
	upgrade_array.append(Dynamic.grow_mod)
	upgrade_array.append(Dynamic.crop_yield)
	upgrade_array.append(Dynamic.process_speed)
	upgrade_array.append(Dynamic.cook_speed)
	upgrade_array.append(Dynamic.mix_speed)
	upgrade_array.append(Dynamic.new_tea)
	upgrade_array.append(Dynamic.new_crop)
	return upgrade_array
	
func _get_diff_danger() -> Array:
	var dd_array: Array = []
	dd_array.append(Dynamic.difficulty_setting)
	dd_array.append(Dynamic.danger_setting)
	dd_array.append(Dynamic.starting_money)
	dd_array.append(Dynamic.starting_tip)
	dd_array.append(Dynamic.upgrade_cost)
	dd_array.append(Dynamic.seed_cost)
	dd_array.append(Dynamic.disappoint)
	dd_array.append(Dynamic.neglect)
	dd_array.append(Dynamic.forget)
	return dd_array
