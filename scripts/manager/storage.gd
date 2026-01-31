class_name Storage extends StaticBody3D

@onready var canvas_layer: CanvasLayer = $CanvasLayer
@onready var inventory_hud: StorageHUD = %InventoryHUD

func _ready() -> void:
	canvas_layer.hide()

func init_gui_scene() -> void:
	canvas_layer.show()
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	inventory_hud.open()
	
func close() -> void:
	canvas_layer.hide()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	inventory_hud.close()
