extends StaticBody3D

signal craft_closed

@export_enum("Process", "Cook", "Mix") var machine_type: int = 0
@export var recipe_upgrades: RecipeUpgradeGroup
@export var crafting_scene: PackedScene = preload("res://scenes/prefab/gui_interface/crafting_hud.tscn")

@onready var sub_viewport: SubViewport = %SubViewport

var new_crafting_scene = null
var available_recipes: Array[Recipe] = []

func _ready() -> void:
	add_recipes()
	
func add_recipes() -> void:
	var upgrade_level: int
	
	match machine_type:
		0: upgrade_level = Dynamic.processor
		1: upgrade_level = Dynamic.cooker
		2: upgrade_level = Dynamic.mixer
	
	available_recipes.clear()
	for i in range(upgrade_level):
		available_recipes.append_array(recipe_upgrades.upgrade(i))

func craft(player_hud: PlayerHUD) -> void:
	if !player_hud.close_crafting.has_connections():
		player_hud.close_crafting.connect(_close)
	new_crafting_scene = crafting_scene.instantiate()
	new_crafting_scene.set_recipes(available_recipes)
	sub_viewport.add_child(new_crafting_scene)
	new_crafting_scene.open()
	
func _close() -> void:
	if new_crafting_scene != null:
		new_crafting_scene.close()
		new_crafting_scene.call_deferred("queue_free")
		craft_closed.emit()
