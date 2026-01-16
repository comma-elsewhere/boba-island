extends Node
var _empty_color: Color = Color("9fb8c600")
var _water_color: Color = Color("6aaec654")
var _gold_color: Color = Color("a86407cc")
var _copper_color: Color = Color("a84e07cc")
var _amber_color: Color = Color("8b3807d9")
var _caramel_color: Color = Color("fba670e1")
var _orange_jade: Color = Color("ff8f488a")
var _green_jade: Color = Color("00a548aa")
var _opaque_jade: Color = Color("008e54f1")
var _lavender_jade: Color = Color("8381c6")

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

func get_tea_color(tea: int) -> Color:
	var tea_color: Color
	match tea:
		Static.TEA.ASSAM: tea_color = _copper_color
		Static.TEA.CEYLON: tea_color = _gold_color
		Static.TEA.CHAI: tea_color = _caramel_color
		Static.TEA.EARL_GREY: tea_color = _amber_color
		Static.TEA.HOJICHA: tea_color = _amber_color
		Static.TEA.JASMINE: tea_color = _gold_color
		Static.TEA.MINT: tea_color = _orange_jade
		Static.TEA.SENCHA: tea_color = _green_jade
		Static.TEA.OOLONG: tea_color = _copper_color
		Static.TEA.MATCHA: tea_color = _opaque_jade
		Static.TEA.TARO: tea_color = _lavender_jade
		Static.TEA.WATER: tea_color = _water_color
		Static.TEA.EMPTY: tea_color = _empty_color
	return tea_color

func get_flavor_num(item_name: String) -> int:
	if item_name == "Assam":
		return Static.TEA.ASSAM
	elif item_name == "Ceylon":
		return Static.TEA.CEYLON
	elif item_name == "Chai":
		return Static.TEA.CHAI
	elif item_name == "Earl Grey":
		return Static.TEA.EARL_GREY
	elif item_name == "Hojicha":
		return Static.TEA.HOJICHA
	elif item_name == "Jasmine":
		return Static.TEA.JASMINE
	elif item_name == "Moroccan Mint":
		return Static.TEA.MINT
	elif item_name == "Sencha":
		return Static.TEA.SENCHA
	elif item_name == "Oolong":
		return Static.TEA.OOLONG
	elif item_name == "Matcha Powder":
		return Static.TEA.MATCHA
	elif item_name == "Taro Puree":
		return Static.TEA.TARO
	else: return 0
