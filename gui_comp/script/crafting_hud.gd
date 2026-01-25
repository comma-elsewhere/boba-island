class_name CraftingHUD extends PanelContainer

signal craft_pending(result: Array[Item])

@export var crafting_item: PackedScene
@export var crafting_check: Array[int] = [0]

@onready var recipe_list: ItemList = %RecipeList
@onready var ingredients_container: ItemGrid = %IngredientsContainer
@onready var results_container: ItemGrid = %ResultsContainer
@onready var crafting_button: Button = %CraftingButton

var player: Player

var recipes: Array[Recipe] = []

var _selected_recipe: Recipe

func _ready() -> void:
	player = get_tree().get_first_node_in_group("Player")
	recipe_list.item_selected.connect(_on_recipe_list_item_selected)
	crafting_button.button_up.connect(_on_crafting_button_button_up)
	
	recipe_list.clear()
		
	for recipe in recipes:
		var index = recipe_list.add_item(recipe.result[0].name)
		recipe_list.set_item_metadata(index, recipe)
		
	if !recipes.is_empty():
		recipe_list.select(0)
		_on_recipe_list_item_selected(0)
		_enable_crafting()
		crafting_button.disabled = crafting_check.has(0)
		
func set_recipes(new_recipes: Array[Recipe]) -> void:
	recipes.clear()
	recipes = new_recipes
	
func open() -> void:
	show()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	crafting_check[0] = 0
	
func close() -> void:
	hide()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _on_recipe_list_item_selected(index: int) -> void:
	var recipe: Recipe = recipe_list.get_item_metadata(index)
	_selected_recipe = recipe
	ingredients_container.display(recipe.ingredients)
	results_container.display(recipe.result)
	_enable_crafting()
	crafting_button.disabled = crafting_check.has(0)

func _enable_crafting() -> bool:
	if not player.hud.get_inventory().has_all(_selected_recipe.ingredients):
		crafting_check[0] = 0
		return false
	else:
		crafting_check[0] = 1
		return true

func _on_crafting_button_button_up() -> void:
	for item in _selected_recipe.ingredients:
		player.hud.remove_item_name(item.name)
	
	craft_pending.emit(_selected_recipe.result)
	get_tree().call_group("GUI_Event", "close")
