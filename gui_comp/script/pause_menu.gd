extends PanelContainer

signal quit_game # Connect to parent HUD to run any end of game functions then navigate to main menu

@onready var resume_button: Button = $MarginContainer/VBoxContainer/HBoxContainer/ResumeButton
@onready var quit_button: Button = $MarginContainer/VBoxContainer/HBoxContainer/QuitButton


func _ready() -> void:
	hide()
	resume_button.button_up.connect(close)
	quit_button.button_up.connect(_quit)

# Call from parent HUD when pause button is pressed while unpaused
func open() -> void:
	show()
	get_tree().paused = true
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

# Call from parent HUD when pause button is pressed while paused
func close() -> void:
	hide()
	get_tree().paused = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED

func _quit() -> void:
	get_tree().paused = false
	quit_game.emit()
