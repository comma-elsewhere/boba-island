extends DirectionalLight3D

func mutant_encounter(active: bool) -> void:
	if !active:
		await get_tree().create_timer(1.0).timeout
	light_negative = active
