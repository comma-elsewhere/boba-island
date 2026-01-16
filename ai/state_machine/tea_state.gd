extends LimboState

@onready var animation_player: AnimationPlayer = %AnimationPlayer
@onready var teacup_button: Button = %TeacupButton

func _enter() -> void:
	animation_player.animation_finished.connect(_enable_button)
	teacup_button.button_up.connect(_finish)
	
	animation_player.play("pour_tea")
	
func _enable_button(anim_name: StringName) -> void:
	if anim_name == "pour_tea":
		teacup_button.disabled = false
		
		
func _finish() -> void:
	agent.finish_ceremony()
	
	animation_player.disconnect("animation_finished", _enable_button)
	teacup_button.disconnect("button_up", _finish)
