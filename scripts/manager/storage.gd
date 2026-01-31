class_name Storage extends StaticBody3D

@onready var canvas_layer: CanvasLayer = %CanvasLayer

func _ready() -> void:
	canvas_layer.hide()

func init_gui_scene() -> void:
	canvas_layer.show()
	
func close() -> void:
	canvas_layer.hide()
