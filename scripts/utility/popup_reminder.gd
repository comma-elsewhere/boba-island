extends PanelContainer

const POPUP := "Press TAB to check your\nPostcard from Grandpa!"

func _ready() -> void:
	if Dynamic.load_game:
		hide()
	else:
		%Reminder.text = POPUP
		
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("library") and visible:
		hide()
