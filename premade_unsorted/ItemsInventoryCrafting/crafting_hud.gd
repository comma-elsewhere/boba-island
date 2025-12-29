extends PanelContainer

@export var crafting_item: PackedScene

@onready var recipe_list: ItemList = %RecipeList
@onready var ingredients_container: ItemGrid = %IngredientsContainer
@onready var results_container: ItemGrid = %ResultsContainer
@onready var crafting_button: Button = %CraftingButton


var _inventory: Inventory
var _selected_recipe: Recipe

# Pass through current available recipes and current inventory
func open(recipes: Array[Recipe], inventory: Inventory) -> void:
	show()
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	
	_inventory = inventory
	
	recipe_list.clear()
	for recipe in recipes:
		var index = recipe_list.add_item(recipe.recipe_result.name)
		recipe_list.set_item_metadata(index, recipe)
	
	if !recipes.is_empty():
		recipe_list.select(0)
		_on_recipe_list_item_selected(0)
		
# Returns updated invetory on close()
func close() -> Inventory:
	hide()
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	return _inventory


func _on_recipe_list_item_selected(index: int) -> void:
	var recipe: Recipe = recipe_list.get_item_metadata(index)
	_selected_recipe = recipe
	ingredients_container.display(recipe.ingredients)
	results_container.display(recipe.results)
	
	crafting_button.disabled = not _inventory.has_all(_selected_recipe.ingredients)


func _on_crafting_button_button_up() -> void:
	for item in _selected_recipe.ingredients:
		_inventory.remove_item(item)
		
	for item in _selected_recipe.results:
		_inventory.add_item(item)
		
	crafting_button.disabled = not _inventory.has_all(_selected_recipe.ingredients)
