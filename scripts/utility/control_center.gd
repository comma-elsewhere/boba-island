extends Control
# GUI 
@onready var gaiwan_button: Button = %GaiwanButton
@onready var teapot_button: Button = %TeapotButton
@onready var teacup_button: Button = %TeacupButton
@onready var again_button: Button = %AgainButton
@onready var done_button: Button = %DoneButton
@onready var heat_slider: VSlider = %HeatSlider
# Audio
@onready var wet_click_player: AudioStreamPlayer = $WetClickPlayer

func _ready() -> void:
	gaiwan_button.button_down.connect(_play_audio)
	teapot_button.button_down.connect(_play_audio)
	teacup_button.button_down.connect(_play_audio)
	again_button.button_down.connect(_play_audio)
	done_button.button_down.connect(_play_audio)
	heat_slider.drag_started.connect(_play_audio)
	
func _play_audio() -> void:
	wet_click_player.play()
