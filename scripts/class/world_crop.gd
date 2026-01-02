class_name WorldCrop extends Node3D

@export var crop_data: Crop

@onready var water_bar: TextureProgressBar = %WaterBar
@onready var grow_time: Label = %GrowTime
@onready var canvas_modulate: CanvasModulate = %CanvasModulate
@onready var gui_3d_visualizer: MeshInstance3D = %GUI_3DVisualizer
@onready var bt_player: BTPlayer = $BTPlayer
@onready var animation_player: AnimationPlayer = $AnimationPlayer




var physical_crop: Node3D = null
var static_body: StaticBody3D

var mutated: bool = false

func spawn_physical_crop(grow_index: int) -> void:
	if grow_index < crop_data.grow_meshes.size():
		if physical_crop != null:
			physical_crop.call_deferred("queue_free")
		
		_spawn_with_static_body(crop_data.grow_meshes[grow_index])
		
func fill_water() -> void:
	water_bar.value = water_bar.max_value
		
		
func reduce_water(current_water: float) -> void:
	water_bar.value = current_water
	
func set_timer(current_time: float) -> void:
	@warning_ignore("integer_division")
	var minute: int = int(current_time) / 60
	var second: int = int(current_time) % 60
	grow_time.text = str(minute) + ":" + str(second)
	
func modulate_red(red: bool) -> void:
	if red:
		canvas_modulate.color = Color("ff0000")
	else:
		canvas_modulate.color = Color("ffffff")
	
	
func allow_harvest() -> void: 
	bt_player.call_deferred("queue_free")
	gui_3d_visualizer.call_deferred("queue_free")
	static_body.set_collision_mask_value(3, true)
	static_body.set_collision_layer_value(3, true)
	
	
func harvest() -> Crop:
	animation_player.play("harvest")
	return crop_data

func _find_first_mesh_instance(node: Node) -> MeshInstance3D:
	if node is MeshInstance3D:
		return node
	for child in node.get_children():
		var result = _find_first_mesh_instance(child)
		if result:
			return result
	return null

func _spawn_with_static_body(packed_scene) -> void:
	physical_crop = packed_scene.instantiate() as Node3D

	var mesh_instance = _find_first_mesh_instance(physical_crop)
	if mesh_instance and mesh_instance.mesh:
		static_body = StaticBody3D.new()
		var shape = mesh_instance.mesh.create_convex_shape()
		var col_shape = CollisionShape3D.new()
		col_shape.shape = shape

		self.add_child(physical_crop)
		physical_crop.add_child(static_body)
		static_body.add_child(col_shape)
