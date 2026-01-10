extends Node

#Save and load
var load_game: bool = false
var drink_order: DrinkRecipe = null

# Financial variables
var total_money: int = 100
var total_debt: int = 1000000
var today_earned: int = 0
var orders_filled: int = 0
var tips_earned: int = 0
var misc_earned: int = 0
var upgrade_spent: int = 0
var seed_spent: int = 0

# Upgradable variables
var inventory_space: int = 6
var moisture_loss: float = 5.0
var grow_mod: float = 2.0
var crop_yield: int = 1
var process_speed: float = 1.0
var cook_speed: float = 1.0
var mix_speed: float = 1.0
var new_tea: int = 3 # Min 3, Max 11
var new_crop: int = 0 # Min 0, Max 2

# Recipe Upgrade tracking - minimum 1
var processor: int = 1 # Max 4
var cooker: int = 1 # Max 2
var mixer: int = 4 # Max 4

#Difficulty/Danger settings
var difficulty_setting: int = 1
var danger_setting: int = 1
var starting_money: int = 1
var starting_tip: int = 1
var upgrade_cost: int = 1
var seed_cost: int = 1
var disappoint: int = 2
var neglect: int = 5
var forget: int = 5
