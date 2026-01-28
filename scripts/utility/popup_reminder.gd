extends PanelContainer

const POPUP := "Press TAB to check your\nPostcard from Grandpa!"
const QUESTS := "Plant, harvest, and process two sugar cane\nBrew a cup of Ceylon Tea\nServe a finished drink to a customer"
const DONE := "You're well on your way to becoming a tea master,\nhere's a little extra to help you pay off that debt! (+$100.0)\nCheck the bookshelf to make payments and get upgrades."

@onready var reminder: Label = %Reminder

func _ready() -> void:
	if Dynamic.tutorial_on:
		reminder.text = POPUP
		get_tree().get_first_node_in_group("DrinkOrders").drink_served.connect(_hide_forever)
	else:
		hide()
		
func _input(event: InputEvent) -> void:
	if Dynamic.tutorial_on:
		if event.is_action_pressed("library") and visible:
			hide()
		elif event.is_action_pressed("library"):
			set_anchors_and_offsets_preset(Control.PRESET_TOP_LEFT)
			reminder.text = QUESTS
			show()

func _hide_forever() -> void:
	Dynamic.tutorial_on = false
	set_anchors_and_offsets_preset(Control.PRESET_CENTER_LEFT)
	reminder.text = DONE
	Dynamic.total_money += 10000
	await get_tree().create_timer(5.0).timeout
	hide()
