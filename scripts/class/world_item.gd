class_name WorldItem extends RigidBody3D

@export var item_data: Item

func _ready():
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

		return instantiated_scene
	return null
