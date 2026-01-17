extends LimboState

@onready var teapot_button: Button = %TeapotButton
@onready var heat_slider: VSlider = %HeatSlider
@onready var teapot_lid: MeshInstance3D = %TeapotLid

func _enter() -> void:
	teapot_button.button_up.connect(_proceed_to_water)
	
	heat_slider.editable = true
	teapot_button.disabled = false
	
func _proceed_to_water() -> void:
	get_root().dispatch("proceed_to_water")
	
func _exit() -> void:
	heat_slider.editable = false
	teapot_button.disabled = false
	teapot_lid.hide()
	
	teapot_button.disconnect("button_up", _proceed_to_water)
