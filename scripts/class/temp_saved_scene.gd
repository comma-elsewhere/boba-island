extends Node3D

func on_save(save_data: Array[SavedData]) -> void:
	var my_data: SavedData = SavedData.new()
	my_data.position = global_position
	my_data.scene_file_path = scene_file_path
	
	save_data.append(my_data)

func on_preload() -> void:
	get_parent().remove_child(self)
	queue_free()

func on_load(save_data: SavedData) -> void:
	var my_data: SavedData = save_data
	global_position = my_data.position
