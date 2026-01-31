extends Control

@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var game_settings: VBoxContainer = %GameSettings
@onready var diificulty_list: ItemList = %DiificultyList
@onready var tutorial_enabled_button: CheckBox = %TutorialEnabledButton
@onready var done_button: Button = %DoneButton

var MAIN := load("res://scenes/level/world_root.tscn")

func _ready() -> void:
	if Dynamic.load_game:
		game_settings.hide()
	else:
		tutorial_enabled_button.button_pressed = Dynamic.tutorial_on
		_set_difficulty(1)
		_new_game_unlocks()
		_new_game_reset_stats()
		game_settings.show()
		done_button.button_up.connect(_play_load_anim)
		tutorial_enabled_button.toggled.connect(_enable_tutorial)
		diificulty_list.item_selected.connect(_set_difficulty)

func _play_load_anim() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	$VBoxContainer.hide()
	animation_player.play("load_game")

func load_game() -> void:
	get_tree().change_scene_to_packed(MAIN)
	
func _new_game_unlocks() -> void:
	# Set starter things
	Dynamic.unlocked_book[Static.BOOKS.GRANDPA] = Static.BOOKS.GRANDPA + 1
	Dynamic.unlocked_book[Static.BOOKS.HOSPICE] = Static.BOOKS.HOSPICE + 1
	Dynamic.unlocked_book[Static.BOOKS.DEBT] = Static.BOOKS.DEBT + 1
	Dynamic.unlocked_book[Static.BOOKS.WILL] = Static.BOOKS.WILL + 1
	Dynamic.unlocked_crop[Static.CROP.SUGAR_CANE] = Static.CROP.SUGAR_CANE + 1
	Dynamic.unlocked_tea[Static.TEA.CEYLON] = Static.TEA.CEYLON + 1
	Dynamic.unlocked_tea[Static.TEA.SENCHA] = Static.TEA.SENCHA + 1

func _new_game_reset_stats() -> void:
	Dynamic.inventory_space = 4 # Min 3, Max 9 --> 5, 7, 9 --> +2 three times
	Dynamic.moisture_loss = 3.2 # Min 0.5, Max 8.0 --> 5.5, 3.0, 0.5 --> -0.1 three times
	Dynamic.grow_mod = 4.0 # Min 0.5, Max 4.0 --> 2.0, 1.0, 0.5 --> /2 three times
	Dynamic.crop_yield = 1 # Min 1, Max 4 --> 2, 3, 4 --> +1 three times ---> need inventory upgrade
	Dynamic.process_speed = 2.5 # Min 0.25, Max 2.0 --> 1.0, 0.5, 0.25 --> /2 three times
	Dynamic.cook_speed = 2.5 # Min 0.25, Max 2.0 --> "" ""
	Dynamic.mix_speed = 2.5 # Min 0.25, Max 2.0 --> "" ""
	Dynamic.processor = 1 # Max 4
	Dynamic.cooker = 1 # Max 2
	Dynamic.mixer = 1 # Max 4


func _set_difficulty(setting_id: int) -> void:
	Dynamic.difficulty_setting = setting_id
	match setting_id:
		Static.SET.LIGHT:
			Dynamic.starting_money = Static.LIGHT_MONEY
			Dynamic.starting_tip = Static.LIGHT_TIP
			Dynamic.base_price = Static.LIGHT_PRICE
			Dynamic.seed_cost = Static.LIGHT_SEED
			Dynamic.disappoint = Static.MEDIUM_DISAPPOINT
			Dynamic.neglect = Static.MEDIUM_NEGLECT
			Dynamic.forget = Static.MEDIUM_FORGET
		Static.SET.MEDIUM:
			Dynamic.starting_money = Static.MEDIUM_MONEY
			Dynamic.starting_tip = Static.MEDIUM_TIP
			Dynamic.base_price = Static.MEDIUM_PRICE
			Dynamic.seed_cost = Static.MEDIUM_SEED
			Dynamic.disappoint = Static.MEDIUM_DISAPPOINT
			Dynamic.neglect = Static.MEDIUM_NEGLECT
			Dynamic.forget = Static.MEDIUM_FORGET
		Static.SET.HARD:
			Dynamic.starting_money = Static.MEDIUM_MONEY
			Dynamic.starting_tip = Static.MEDIUM_TIP
			Dynamic.base_price = Static.MEDIUM_PRICE
			Dynamic.seed_cost = Static.MEDIUM_SEED
			Dynamic.disappoint = Static.HARD_DISAPPOINT
			Dynamic.neglect = Static.HARD_NEGLECT
			Dynamic.forget = Static.HARD_FORGET
			
	Dynamic.total_money = Dynamic.starting_money

func _enable_tutorial(toggled_on: bool) -> void:
	Dynamic.tutorial_on = toggled_on
