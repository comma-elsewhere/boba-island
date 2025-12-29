extends PanelContainer

const NEW_GAME := ""


func _on_start_button_button_up() -> void:
	get_tree().change_scene_to_file(NEW_GAME)


func _on_quit_button_button_up() -> void:
	get_tree().quit()
