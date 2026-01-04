extends Node

func find_first_mesh_instance(node: Node) -> MeshInstance3D:
	if node is MeshInstance3D:
		return node
	for child in node.get_children():
		var result = find_first_mesh_instance(child)
		if result:
			return result
	return null
	
	
func display_time(hour: int, minute: int) -> String:
	var minute_string: String
	if minute < 10:
		minute_string = "0" + str(minute)
	else:
		minute_string = str(minute)
	
	return str(hour) + ":" + minute_string
	
	
func display_money(money: int) -> String:
	return "$%.2f" % (float(money)/100)
