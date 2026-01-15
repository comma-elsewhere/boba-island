extends StaticBody3D

@export_enum("Process", "Cook", "Mix") var machine_type: int = 0
@export var recipe_upgrades: RecipeUpgradeGroup
@export var crafting_scene: PackedScene = preload("res://scenes/prefab/gui_interface/crafting_hud.tscn")

@onready var canvas_layer: CanvasLayer = %GUI_Parent
@onready var wait_time: Timer = %WaitTime
@onready var shaker: ShakerComponent3D = %ShakerComponent3D

const PROCESS := 3.0
const COOK := 2.0
const MIX := 2.0

var new_crafting_scene: CraftingHUD = null
var available_recipes: Array[Recipe] = []
var pending_result: Array[Item] = []

func _ready() -> void:
	add_recipes()
	_enable_display(false)
	
func add_recipes() -> void:
	var upgrade_level: int
	
	match machine_type:
		0: upgrade_level = Dynamic.processor
		1: upgrade_level = Dynamic.cooker
		2: upgrade_level = Dynamic.mixer
	
	available_recipes.clear()
	for i in range(upgrade_level):
		available_recipes.append_array(recipe_upgrades.upgrade(i))

func init_gui_scene() -> void:
	if wait_time.is_stopped():
		new_crafting_scene = crafting_scene.instantiate()
		new_crafting_scene.set_recipes(available_recipes)
		new_crafting_scene.craft_pending.connect(_craft_pending)
		canvas_layer.add_child(new_crafting_scene)
		new_crafting_scene.open()

func close() -> void:
	if new_crafting_scene != null:
		new_crafting_scene.close()
		new_crafting_scene.call_deferred("queue_free")

func pickup_array() -> Array[Item]:
	_enable_display(false)
	return pending_result

func _craft_pending(result: Array[Item]) -> void:
	pending_result = result
	%ItemTexture.texture = result[0].icon
	%WaitTime.start(_return_time())
	shaker.play_shake()

func _enable_display(enable: bool) -> void:
	%IconDisplay.visible = enable
	%CollisionShape3D.disabled = !enable
	if !enable:
		%ItemTexture.texture = null

func _return_time() -> float:
	var time: float
	match machine_type:
		0: time = PROCESS * Dynamic.process_speed
		1: time = COOK * Dynamic.cook_speed
		2: time = MIX * Dynamic.mix_speed
	shaker.duration = time
	return time

func _on_wait_time_timeout() -> void:
	_enable_display(true)
	print("DONE")
