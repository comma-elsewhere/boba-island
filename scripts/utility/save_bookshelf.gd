extends StaticBody3D

@onready var canvas_layer: CanvasLayer = %CanvasLayer
@onready var end_day: Control = %EndDay

func _ready() -> void:
	canvas_layer.hide()
	end_day.save_game.connect(_hide_gui_scene)

func init_gui_scene() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	end_day.set_labels()
	canvas_layer.show()
	
func close() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	canvas_layer.hide()
	
func _hide_gui_scene() -> void:
	get_tree().call_group("GUI_Event", "close")
