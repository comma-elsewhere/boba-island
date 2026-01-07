class_name SaverLoader extends Node
@export var world_root: Node3D
@export var player: Player

func _ready() -> void:
	await get_tree().create_timer(0.5).timeout
	if Dynamic.load_game:
		call_deferred("load_game")
		Dynamic.load_game = false

func save_game() -> void:
	var saved_game: SavedGame = SavedGame.new()
	
	saved_game.player_inventory.clear()
	for item in player.hud.hotbar_array:
		saved_game.player_inventory.append(item)
	
	saved_game.player_position = player.global_position
	saved_game.financial_variables = _get_finances()
	saved_game.upgrade_variables = _get_upgrades()
	saved_game.diff_danger_variables = _get_diff_danger()
	get_tree().call_group("GameEvent", "on_save", saved_game.saved_data)
	
	ResourceSaver.save(saved_game, "user://savedata.res")
	
func load_game() -> void:
	var saved_game = load("user://savedata.res")
	
	get_tree().call_group("GameEvent","on_preload")
	
	_set_finances(saved_game.financial_variables)
	_set_upgrades(saved_game.upgrade_variables)
	_set_diff_danger(saved_game.diff_danger_variables)
	player.global_position = saved_game.player_position
	
	for item in saved_game.player_inventory:
		player.hud.add_item(item)
	
	for item in saved_game.saved_data:
		print(item.position)
		print(item.scene_file_path)
		var load_item = load(item.scene_file_path) as PackedScene
		var instantiate_item = load_item.instantiate()
		world_root.add_child.call_deferred(instantiate_item)
		instantiate_item.call_deferred("on_load", item)
	

func _set_finances(data_array: Array) -> void:
	data_array[0] = Dynamic.total_money
	data_array[1] = Dynamic.total_debt
	data_array[2] = Dynamic.today_earned
	data_array[3] = Dynamic.orders_filled
	data_array[4] = Dynamic.tips_earned
	data_array[5] = Dynamic.misc_earned
	data_array[6] = Dynamic.upgrade_spent
	data_array[7] = Dynamic.seed_spent

func _set_upgrades(data_array: Array) -> void:
	data_array[0] = Dynamic.inventory_space
	data_array[1] = Dynamic.moisture_loss
	data_array[2] = Dynamic.grow_mod
	data_array[3] = Dynamic.crop_yield
	data_array[4] = Dynamic.process_speed
	data_array[5] = Dynamic.cook_speed
	data_array[6] = Dynamic.mix_speed
	data_array[7] = Dynamic.new_tea
	data_array[8] = Dynamic.new_crop

func _set_diff_danger(data_array: Array) -> void:
	data_array[0] = Dynamic.difficulty_setting
	data_array[1] = Dynamic.danger_setting
	data_array[2] = Dynamic.starting_money
	data_array[3] = Dynamic.starting_tip
	data_array[4] = Dynamic.upgrade_cost
	data_array[5] = Dynamic.seed_cost
	data_array[6] = Dynamic.disappoint
	data_array[7] = Dynamic.neglect
	data_array[8] = Dynamic.forget

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
