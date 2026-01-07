extends PanelContainer

signal quit_game # Connect to parent HUD to run any end of game functions then navigate to main menu

@onready var return_button: Button = %ReturnButton
@onready var resume_button: Button = %ResumeButton
@onready var options_button: Button = %OptionsButton
@onready var save_button: Button = %SaveButton
@onready var quit_button: Button = %QuitButton


func _ready() -> void:
	hide()
	return_button.button_up.connect(_toggle_options.bind(false))
	options_button.button_up.connect(_toggle_options.bind(true))
	save_button.button_up.connect(_save)
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

func _save() -> void:
	close()
	get_tree().call_group("SaverLoader", "save_game")

func _quit() -> void:
	get_tree().paused = false
	quit_game.emit()

func _toggle_options(toggle_on: bool) -> void:
	%Options.visible = toggle_on
	%PauseMenu.visible = !toggle_on
