extends MarginContainer

@onready var sensitivity_slider: HSlider = %SensitivityButton
@onready var volume_slider: HSlider = %VolumeSlider
@onready var mute_button: CheckButton = %MuteButton
@onready var res_options: OptionButton = %ResOptions
@onready var fullscreen_button: CheckButton = %FullscreenButton
@onready var v_sync_button: CheckButton = %VSyncButton
@onready var camera_shake_button: CheckButton = %CameraShakeButton
@onready var headbob_button: CheckButton = %HeadbobButton
@onready var reticle_button: CheckButton = %ReticleButton


func _ready() -> void:
	sensitivity_slider.value = Dynamic.mouse_sensitivity
	volume_slider.value = AudioServer.get_bus_volume_linear(0)
	v_sync_button.button_pressed = DisplayServer.VSyncMode.VSYNC_ENABLED
	camera_shake_button.button_pressed = Dynamic.camera_shake
	headbob_button.button_pressed = Dynamic.headbob
	reticle_button.button_pressed = Dynamic.reticle
	
	sensitivity_slider.value_changed.connect(_on_sensitivity_slider_changed)
	volume_slider.value_changed.connect(_on_volume_slider_changed)
	mute_button.toggled.connect(_on_mute_toggled)
	res_options.item_selected.connect(_on_res_option_selected)
	fullscreen_button.toggled.connect(_on_fullscreen_toggled)
	v_sync_button.toggled.connect(_on_vsync_toggled)
	camera_shake_button.toggled.connect(_on_camera_shake_toggled)
	headbob_button.toggled.connect(_on_headbob_toggled)
	reticle_button.toggled.connect(_on_reticle_toggled)
	
func _on_sensitivity_slider_changed(value: float) -> void:
	Dynamic.mouse_sensitivity = value

func _on_volume_slider_changed(value: float) -> void:
	AudioServer.set_bus_volume_linear(0, value)

func _on_mute_toggled(toggled_on: bool) -> void:
	AudioServer.set_bus_mute(0, toggled_on)

func _on_res_option_selected(index: int) -> void:
	match index:
		0:
			DisplayServer.window_set_size(Vector2i(1920,1080))
		1:
			DisplayServer.window_set_size(Vector2i(1600,900))
		2:
			DisplayServer.window_set_size(Vector2i(1280,720))

func _on_fullscreen_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func _on_vsync_toggled(toggled_on: bool) -> void:
	if toggled_on:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_ENABLED)
	else:
		DisplayServer.window_set_vsync_mode(DisplayServer.VSYNC_DISABLED)
		
func _on_camera_shake_toggled(toggle_on: bool) -> void:
	Dynamic.camera_shake = toggle_on
	
func _on_headbob_toggled(toggle_on: bool) -> void:
	Dynamic.headbob = toggle_on
	
func _on_reticle_toggled(toggle_on: bool) -> void:
	Dynamic.reticle = toggle_on
