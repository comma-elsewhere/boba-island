extends Node3D

func reset_children() -> void:
	for mesh in get_children():
		mesh.scale = Vector3.ONE
		mesh.global_position = Vector3.ZERO
