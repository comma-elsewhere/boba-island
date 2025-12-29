extends PanelContainer

func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if visible:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			hide()
		elif Input.mouse_mode != Input.MOUSE_MODE_CAPTURED:
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
