extends LimboState

@onready var animation_player: AnimationPlayer = %AnimationPlayer

func _enter() -> void:
	animation_player.animation_finished.connect(_proceed)
	
	animation_player.play("add_water")
	
func _proceed(anim_name: StringName) -> void:
	if anim_name == "add_water":
		get_root().dispatch("proceed_to_brew")
	
func _exit() -> void:
	animation_player.disconnect("animation_finished", _proceed)
