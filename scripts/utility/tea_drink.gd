extends Node3D

@export var item_data: Drink
@export_group("Tea Colors")
@export_subgroup("Strawberry")
@export var strawberry : Color
@export_subgroup("Plain Tea")
@export var plain_black : Color = Color("8b3807d9")
@export var plain_green : Color = Color("a86407cc")
@export var plain_oolong : Color = Color("ff8f488a")
@export_subgroup("Milk Tea")
@export var milk_black : Color = Color("fba670e1")
@export var milk_green : Color
@export var milk_oolong : Color
@export var milk_matcha : Color = Color("008e54f1")
@export var milk_taro : Color = Color("8381c6")

@onready var tea: MeshInstance3D = %Tea
@onready var boba: Node3D = %Boba

func drink_setup(data: Item) -> void:
	item_data = data as Drink
	
func _ready() -> void:
	tea.surface_get_material(0).albedo_color = get_color()
	tea.surface_get_material(1).albedo_color = get_color()
	boba.visible = show_boba()

func get_color() -> Color:
	if item_data.drink_type < 2:
		match item_data.tea_type:
			"Black": return plain_black
			"Green": return plain_green
			"Oolong": return plain_oolong
	elif item_data.drink_type < 4:
		match item_data.tea_type:
			"Black": return milk_black
			"Green": return milk_green
			"Oolong": return milk_oolong
			"Matcha": return milk_matcha
			"Taro": return milk_taro
	return strawberry

func show_boba() -> bool:
	if item_data.drink_type == 1:
		return true
	elif item_data.drink_type == 3:
		return true
	elif item_data.drink_type == 5:
		return true
	return false
