extends StaticBody3D

signal craft_closed

@export_enum("Process", "Cook", "Mix") var machine_type: int = 0
@export var recipe_upgrades: RecipeUpgradeGroup
@export var crafting_scene: PackedScene = preload("res://scenes/prefab/gui_interface/crafting_hud.tscn")

@onready var canvas_layer: CanvasLayer = %CanvasLayer

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

func craft() -> void:
	new_crafting_scene = crafting_scene.instantiate()
	new_crafting_scene.set_recipes(available_recipes)
	canvas_layer.add_child(new_crafting_scene)
	new_crafting_scene.open()
	
# make a gettree().groupcall("close") for this coming from playerhud
func close() -> void:
	if new_crafting_scene != null:
		new_crafting_scene.close()
		new_crafting_scene.call_deferred("queue_free")
		craft_closed.emit()

# Need to connect to a signal from crafting scene to accept results of craft as pending
# set timer based on processing time mod
# disable self for that amount of time
# animate with shaker on scale while processing
# return clickable gui element in 3d space that gives you your crafted product at the end
