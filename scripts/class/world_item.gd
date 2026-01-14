class_name WorldItem extends RigidBody3D

@export var item_data: Item

func _ready():
	if item_data.mesh:
		_spawn_item_with_collision(item_data.mesh)
	
func set_data(data) -> void:
	item_data = data
	
func pickup() -> Item:
	call_deferred("queue_free")
	return item_data

func _spawn_item_with_collision(packed_scene) -> Node3D:
	var instantiated_scene = packed_scene.instantiate()
	var mesh_instance = Kinetic.find_first_mesh_instance(instantiated_scene)
	if Kinetic.mesh_to_collision(mesh_instance, self):

		self.add_child(instantiated_scene)
		self.set_collision_mask_value(5,true) # collides with dirt
		self.set_collision_layer_value(4, true) # pickup by racyast
		if item_data.has_method("get_drink_name"):
			self.set_collision_layer_value(6, true) # detected by drinkzone area
			
		return instantiated_scene
	return null

# None of the below is functional right now and I couldn't care less
# It's a feature not a bug

#func on_save(save_data: Array[SavedData]) -> void:
	#var my_data = SavedItem.new()
	#my_data.position = global_position
	#my_data.scene_file_path = scene_file_path
	#my_data.data = item_data
	#
	#save_data.append(my_data)
#
#func on_preload() -> void:
	#get_parent().remove_child(self)
	#queue_free()
#
#func on_load(save_data: SavedData) -> void:
	#var my_data: SavedItem = save_data as SavedItem
	#global_position = my_data.position
	#item_data = my_data.data
	#_spawn_item_with_collision(item_data.mesh)
