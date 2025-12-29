extends CSGCombiner3D

func subtract_combine(new_csg: CSGSphere3D) -> void:
	new_csg.set_operation(CSGShape3D.OPERATION_SUBTRACTION)
	add_child(new_csg)
	_recalculate_mesh()

func union_combine(new_csg: CSGSphere3D) -> void:
	new_csg.set_operation(CSGShape3D.OPERATION_UNION)
	add_child(new_csg)
	_recalculate_mesh()
	
func _recalculate_mesh() -> void:
	await get_tree().process_frame
	bake_static_mesh()
	bake_collision_shape()
