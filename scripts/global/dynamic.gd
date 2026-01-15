extends Node

#Save and load + progress indicators
var load_game: bool = false
# ---Progress: save as Array[Array]---
var tutorial_progress: Array[int] = []
var unlocked_book: Array[int] = []
var unlocked_tea: Array[int] = []
var unlocked_crop: Array[int] =  []

# Options menu settings, save
var mouse_sensitivity: float = 0.004
# --- Accessibility: save as Array[bool]---
var camera_shake: bool = true
var headbob: bool = true
var reticle: bool = true

# reset on every drink order, no save
var tea_quality: float = 1.0 
var tea_flavor: int

# Financial variables
# consistent through game --- Just save these two as Array[int]
var total_money: int = 1000
var total_debt: int = 1010000
# adjusted and reset daily, no save
var today_earned: int = 0
var orders_filled: int = 0
var tips_earned: int = 0
var crops_harvested: int = 0

# Upgradable variables --- there's no easy way to save these, gotta make a func -- save as Array
var inventory_space: int = 9 # Min 3, Max 9 --> 5, 7, 9 --> +2 three times
var moisture_loss: float = 8.0 # Min 0.5, Max 8.0 --> 5.5, 3.0, 0.5 --> -2.5 three times
var grow_mod: float = 1.0 # Min 0.5, Max 4.0 --> 2.0, 1.0, 0.5 --> /2 three times
var crop_yield: int = 1 # Min 1, Max 4 --> 2, 3, 4 --> +1 three times ---> need inventory upgrade
var process_speed: float = 2.0 # Min 0.25, Max 2.0 --> 1.0, 0.5, 0.25 --> /2 three times
var cook_speed: float = 2.0 # Min 0.25, Max 2.0 --> "" ""
var mix_speed: float = 2.0 # Min 0.25, Max 2.0 --> "" ""

# Recipe Upgrade tracking - minimum 1 --- Save and load as recipe_upgrade: array[int]
var processor: int = 4 # Max 4
var cooker: int = 2 # Max 2
var mixer: int = 4 # Max 4

#Difficulty settings -- Save as Array[int]
# set by play on new game setup screen -- needs to be saved and loaded
var difficulty_setting: int = 1
var danger_setting: int = 1
# set dynamically in code upon load
# ---difficulty---
var starting_money: int = 1
var starting_tip: int = 1
var base_price: int = 1
var seed_cost: int = 1
# ---danger---
var disappoint: int = 1
var neglect: int = 1
var forget: int = 1

# MOVE ALL THIS TO A ONE-TIME SETUP SCREEN ON FIRST LOAD
func _ready() -> void:
	# initialize progress indicators
	unlocked_book.resize(Static.NUMBER_OF_BOOKS)
	unlocked_tea.resize(Static.NUMBER_OF_TEAS)
	unlocked_crop.resize(Static.NUMBER_OF_CROPS)
	# Set starter things
	unlocked_crop[Static.CROP.SUGAR_CANE] = Static.CROP.SUGAR_CANE + 1
	unlocked_tea[Static.TEA.CEYLON] = Static.TEA.CEYLON + 1
	unlocked_tea[Static.TEA.SENCHA] = Static.TEA.SENCHA + 1
	# Set difficulty levels
	_set_danger(Static.SET.HARD)
	_set_difficulty(Static.SET.LIGHT)
	
	# (temp removed for playtesting purposes)
	#total_money = starting_money 


func _set_difficulty(setting_id: int) -> void:
	difficulty_setting = setting_id
	match setting_id:
		Static.SET.LIGHT:
			starting_money = Static.EASY_MONEY
			starting_tip = Static.EASY_TIP
			base_price = Static.EASY_PRICE
			seed_cost = Static.EASY_SEED
		Static.SET.MEDIUM:
			starting_money = Static.NORMAL_MONEY
			starting_tip = Static.NORMAL_TIP
			base_price = Static.NORMAL_PRICE
			seed_cost = Static.NORMAL_SEED
		Static.SET.HARD:
			starting_money = Static.HARD_MONEY
			starting_tip = Static.HARD_TIP
			base_price = Static.HARD_PRICE
			seed_cost = Static.HARD_SEED
			
func _set_danger(setting_id: int) -> void:
	danger_setting = setting_id
	match setting_id:
		Static.SET.LIGHT:
			disappoint = Static.PEACEFUL_DISAPPOINT
			neglect = Static.PEACEFUL_NEGLECT
			forget = Static.PEACEFUL_FORGET
		Static.SET.MEDIUM:
			disappoint = Static.STORY_DISAPPOINT
			neglect = Static.STORY_NEGLECT
			forget = Static.STORY_FORGET
		Static.SET.HARD:
			disappoint = Static.DANGER_DISAPPOINT
			neglect = Static.DANGER_NEGLECT
			forget = Static.DANGER_FORGET
