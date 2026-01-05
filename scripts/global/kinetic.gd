extends Node

func find_first_mesh_instance(node: Node) -> MeshInstance3D:
	if node is MeshInstance3D:
		return node
	for child in node.get_children():
		var result = find_first_mesh_instance(child)
		if result:
			return result
	return null
	
func mesh_to_static_body(mesh_instance: MeshInstance3D, parent_node: Node3D) -> StaticBody3D:
	if mesh_instance and mesh_instance.mesh:
		var new_static_body = StaticBody3D.new()
		var shape = mesh_instance.mesh.create_trimesh_shape()
		var col_shape = CollisionShape3D.new()
		col_shape.shape = shape

		parent_node.add_child(new_static_body)
		new_static_body.add_child(col_shape)
		return new_static_body
	else: return null
	
func mesh_to_collision(mesh_instance: MeshInstance3D, parent_node: Node3D) -> bool:
	if mesh_instance and mesh_instance.mesh:
		var shape = mesh_instance.mesh.create_convex_shape()
		var col_shape = CollisionShape3D.new()
		col_shape.shape = shape
		parent_node.add_child(col_shape)
		return true
	return false
	
func display_time(hour: int, minute: int) -> String:
	var minute_string: String
	if minute < 10:
		minute_string = "0" + str(minute)
	else:
		minute_string = str(minute)
	
	return str(hour) + ":" + minute_string
	
func display_money(money: int) -> String:
	return "$%.2f" % (float(money)/100)
