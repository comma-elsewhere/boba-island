extends PanelContainer

const NEW_GAME := "res://scenes/prefab/boot_screen.tscn"

@onready var continue_button: Button = %ContinueButton

func _ready() -> void:
	var check_save = load("user://savedata.res")
	if check_save != null:
		continue_button.disabled = false

func _on_start_button_button_up() -> void:
	get_tree().change_scene_to_file(NEW_GAME)


func _on_quit_button_button_up() -> void:
	get_tree().quit()
	

func _on_saved_button_button_up() -> void:
	Dynamic.load_game = true
	get_tree().change_scene_to_file(NEW_GAME)
