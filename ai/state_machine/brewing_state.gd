extends LimboState

@onready var gaiwan_button: Button = %GaiwanButton
@onready var brew_timer: Timer = %BrewTimer
@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var gaiwan_bowl: GaiwanBowl = %GaiwanBowl

var not_clicking: bool = false
var color_changed: bool = false

func _enter() -> void:
	animation_player.animation_finished.connect(_handle_transitions)
	
	animation_player.play("start_mix")
	brew_timer.paused = false
	
func _update(_delta: float) -> void:
	if not_clicking:
		_stop_brewing()
	
func _input(event: InputEvent) -> void:
	if event.is_action_released("click"):
		not_clicking = true
	
func _stop_brewing() -> void:
	brew_timer.paused = true
	animation_player.stop()
	get_root().dispatch("stop_brewing")

func _handle_transitions(anim_name: StringName) -> void:
	if anim_name == "start_mix":
		animation_player.play("mix_loop")
	
func _exit() -> void:
	gaiwan_bowl.set_tea()
	animation_player.play("end_mix")
	not_clicking = false
	
	animation_player.disconnect("animation_finished", _handle_transitions)
