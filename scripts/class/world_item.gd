class_name WorldItem extends RigidBody3D

@export var item_data: Item

func _ready():
	_spawn_item_with_collision(item_data.mesh_scene)
	
func pickup() -> Item:
	call_deferred("queue_free")
	return item_data

func _find_first_mesh_instance(node: Node) -> MeshInstance3D:
	if node is MeshInstance3D:
		return node
	for child in node.get_children():
		var result = _find_first_mesh_instance(child)
		if result:
			return result
	return null

func _spawn_item_with_collision(packed_scene) -> Node3D:
	var instantiated_scene = packed_scene.instantiate()

	var mesh_instance = _find_first_mesh_instance(instantiated_scene)
	if mesh_instance and mesh_instance.mesh:
		var shape = mesh_instance.mesh.create_convex_shape()
		var col_shape = CollisionShape3D.new()
		col_shape.shape = shape

		self.add_child(instantiated_scene)
		self.add_child(col_shape)

	return instantiated_scene
