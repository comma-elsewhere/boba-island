extends Control

@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var game_settings: VBoxContainer = %GameSettings
@onready var diificulty_list: ItemList = %DiificultyList
@onready var danger_list: ItemList = %DangerList
@onready var done_button: Button = %DoneButton

var MAIN := load("res://scenes/level/world_root.tscn")

func _ready() -> void:
	if Dynamic.load_game:
		_play_load_anim()
	else:
		_set_difficulty(1)
		_set_danger(1)
		_resize_progress_indicators()
		game_settings.show()
		done_button.button_up.connect(_play_load_anim)
		diificulty_list.item_selected.connect(_set_difficulty)
		danger_list.item_selected.connect(_set_danger)

func _play_load_anim() -> void:
	game_settings.hide()
	animation_player.play("load_game")

func load_game() -> void:
	get_tree().change_scene_to_packed(MAIN)
	
func _resize_progress_indicators() -> void:
	# initialize progress indicators
	Dynamic.unlocked_book.resize(Static.NUMBER_OF_BOOKS)
	Dynamic.unlocked_tea.resize(Static.NUMBER_OF_TEAS)
	Dynamic.unlocked_crop.resize(Static.NUMBER_OF_CROPS)
	# Set starter things
	Dynamic.unlocked_book[Static.BOOKS.HOSPICE] = Static.BOOKS.HOSPICE + 1
	Dynamic.unlocked_book[Static.BOOKS.DEBT] = Static.BOOKS.DEBT + 1
	Dynamic.unlocked_book[Static.BOOKS.WILL] = Static.BOOKS.WILL + 1
	Dynamic.unlocked_crop[Static.CROP.SUGAR_CANE] = Static.CROP.SUGAR_CANE + 1
	Dynamic.unlocked_tea[Static.TEA.CEYLON] = Static.TEA.CEYLON + 1
	Dynamic.unlocked_tea[Static.TEA.SENCHA] = Static.TEA.SENCHA + 1

func _set_difficulty(setting_id: int) -> void:
	Dynamic.difficulty_setting = setting_id
	match setting_id:
		Static.SET.LIGHT:
			Dynamic.starting_money = Static.EASY_MONEY
			Dynamic.starting_tip = Static.EASY_TIP
			Dynamic.base_price = Static.EASY_PRICE
			Dynamic.seed_cost = Static.EASY_SEED
		Static.SET.MEDIUM:
			Dynamic.starting_money = Static.NORMAL_MONEY
			Dynamic.starting_tip = Static.NORMAL_TIP
			Dynamic.base_price = Static.NORMAL_PRICE
			Dynamic.seed_cost = Static.NORMAL_SEED
		Static.SET.HARD:
			Dynamic.starting_money = Static.HARD_MONEY
			Dynamic.starting_tip = Static.HARD_TIP
			Dynamic.base_price = Static.HARD_PRICE
			Dynamic.seed_cost = Static.HARD_SEED
			
	Dynamic.total_money = Dynamic.starting_money
			
func _set_danger(setting_id: int) -> void:
	Dynamic.danger_setting = setting_id
	match setting_id:
		Static.SET.LIGHT:
			Dynamic.disappoint = Static.PEACEFUL_DISAPPOINT
			Dynamic.neglect = Static.PEACEFUL_NEGLECT
			Dynamic.forget = Static.PEACEFUL_FORGET
		Static.SET.MEDIUM:
			Dynamic.disappoint = Static.STORY_DISAPPOINT
			Dynamic.neglect = Static.STORY_NEGLECT
			Dynamic.forget = Static.STORY_FORGET
		Static.SET.HARD:
			Dynamic.disappoint = Static.DANGER_DISAPPOINT
			Dynamic.neglect = Static.DANGER_NEGLECT
			Dynamic.forget = Static.DANGER_FORGET
