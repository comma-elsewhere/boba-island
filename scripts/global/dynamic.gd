extends Node

# Financial variables
var total_money: int = 200
var total_debt: int = 1000000
var today_earned: int = 0
var orders_filled: int = 0
var tips_earned: int = 0
var misc_earned: int = 0
var drink_price: int = 500
var upgrade_cost: int = 0
var seed_cost: int = 0

# Upgradable variables
var inventory_space: int = 5
var moisture_loss: float = 3.0
var grow_mod: float = 1.0
var crop_yield: int = 1
var new_tea: int = 0
var new_crop: int = 0
var process_speed: float = 1.0
var cook_speed: float = 1.0
var mix_speed: float = 1.0

#Difficulty settings
var disappoint: int = 1
var neglect: int = 1
var forget: int = 1
