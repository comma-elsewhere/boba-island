extends LimboState

@onready var gaiwan_button: Button = %GaiwanButton
@onready var teacup_button: Button = %TeacupButton

func _enter() -> void:
	gaiwan_button.disabled = false
	teacup_button.disabled = false
	
	gaiwan_button.button_down.connect(_start_brewing)
	teacup_button.button_up.connect(_proceed_to_tea)
	
func _start_brewing() -> void:
	get_root().dispatch("start_brewing")
	
func _proceed_to_tea() -> void:
	get_root().dispatch("proceed_to_tea")
	
func _exit() -> void:
	gaiwan_button.disabled = true
	teacup_button.disabled = true
	
	teacup_button.disconnect("button_up", _proceed_to_tea)
	gaiwan_button.disconnect("button_down", _start_brewing)
