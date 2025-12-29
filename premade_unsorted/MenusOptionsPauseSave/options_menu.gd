extends MarginContainer

@onready var volume_slider: HSlider = $VBoxContainer/Volume/HSlider
@onready var mute_box: CheckButton = $VBoxContainer/Mute/CheckBox1
@onready var res_options: OptionButton = $VBoxContainer/Resolution/OptionButton
@onready var fullscreen_box: CheckButton = $VBoxContainer/Fullscreen/CheckButton2

func _ready() -> void:
	volume_slider.value = AudioServer.get_bus_volume_linear(0)

func _on_h_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_linear(0, value)


func _on_check_box_1_toggled(toggled_on: bool) -> void:
	AudioServer.set_bus_mute(0, toggled_on)


func _on_option_button_item_selected(index: int) -> void:
	match index:
		0:
			DisplayServer.window_set_size(Vector2i(1920,1080))
		1:
			DisplayServer.window_set_size(Vector2i(1600,900))
		2:
			DisplayServer.window_set_size(Vector2i(1280,720))


func _on_check_button_2_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
