extends Camera3D

@onready var shaker: ShakerComponent3D = %CameraShaker

func mutant_encounter(active: bool) -> void:
	if !active and Dynamic.camera_shake:
		await get_tree().create_timer(0.7).timeout
		shaker.play_shake()
