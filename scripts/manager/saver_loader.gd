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
	
	saved_game.options = _get_options()
	saved_game.accessibility = _get_access()
	saved_game.progress = _get_progress()
	saved_game.finances = _get_finances()
	saved_game.player_upgrades = _get_player_upgrades()
	saved_game.recipe_upgrades = _get_recipe_upgrades()
	saved_game.difficulty = _get_difficulty()
	
	get_tree().call_group("GameEvent", "on_save", saved_game.saved_data)
	
	ResourceSaver.save(saved_game, "user://savedata.res")
	
func load_game() -> void:
	var saved_game = load("user://savedata.res")
	
	get_tree().call_group("GameEvent","on_preload")
	_set_options(saved_game.options)
	_set_access(saved_game.accessibility)
	_set_progress(saved_game.progress) 
	_set_finances(saved_game.finances) 
	_set_player_upgrades(saved_game.player_upgrades) 
	_set_recipe_upgrades(saved_game.recipe_upgrades) 
	_set_difficulty(saved_game.difficulty) 
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
	
func _get_options() -> Array[float]:
	return [Dynamic.mouse_sensitivity]
	
func _set_options(options: Array[float]) -> void:
	Dynamic.mouse_sensitivity = options[0]
	
func _get_access() -> Array[bool]:
	return [Dynamic.camera_shake, Dynamic.headbob, Dynamic.reticle]
	
func _set_access(access: Array[bool]) -> void:
	Dynamic.camera_shake = access[0]
	Dynamic.headbob = access[1]
	Dynamic.reticle = access[2]
	
func _get_progress() -> Array[Array]:
	return [Dynamic.tutorial_progress, Dynamic.unlocked_book, Dynamic.unlocked_tea, Dynamic.unlocked_crop]
	
func _set_progress(progress: Array[Array]) -> void:
	Dynamic.tutorial_progress = progress[0]
	Dynamic.unlocked_book = progress[1]
	Dynamic.unlocked_tea = progress[2]
	Dynamic.unlocked_crop = progress[3]
	
func _get_finances() -> Array[int]:
	return [Dynamic.total_money, Dynamic.total_debt]
	
func _set_finances(finances: Array[int]) -> void:
	Dynamic.total_money = finances[0]
	Dynamic.total_debt = finances[1]
	
func _get_player_upgrades() -> Array:
	return [Dynamic.inventory_space, Dynamic.moisture_loss, Dynamic.grow_mod, Dynamic.crop_yield, Dynamic.process_speed, Dynamic.cook_speed, Dynamic.mix_speed]
	
func _set_player_upgrades(upgrades: Array) -> void:
	Dynamic.inventory_space = upgrades[0]
	Dynamic.moisture_loss = upgrades[1]
	Dynamic.grow_mod = upgrades[2]
	Dynamic.crop_yield = upgrades[3]
	Dynamic.process_speed = upgrades[4]
	Dynamic.cook_speed = upgrades[5]
	Dynamic.mix_speed = upgrades[6]

func _get_recipe_upgrades() -> Array[int]:
	return [Dynamic.processor, Dynamic.cooker, Dynamic.mixer]

func _set_recipe_upgrades(upgrades: Array[int]) -> void:
	Dynamic.processor = upgrades[0]
	Dynamic.cooker = upgrades[1]
	Dynamic.mixer = upgrades[2]
	
func _get_difficulty() -> Array[int]:
	return [Dynamic.difficulty_setting, Dynamic.danger_setting]
	
func _set_difficulty(difficulty: Array[int]) -> void:
	Dynamic.difficulty_setting = difficulty[0]
	Dynamic.danger_setting = difficulty[1]
