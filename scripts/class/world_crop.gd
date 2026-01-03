class_name WorldCrop extends Node3D

@export var crop_data: Crop

@onready var water_bar: TextureProgressBar = %WaterBar
@onready var grow_time: Label = %GrowTime
@onready var canvas_modulate: CanvasModulate = %CanvasModulate
@onready var gui_3d_visualizer: MeshInstance3D = %GUI_3DVisualizer
@onready var bt_player: BTPlayer = $BTPlayer
@onready var animation_player: AnimationPlayer = $AnimationPlayer


var physical_crop: Node3D = null
var static_body: StaticBody3D = null

var mutated: bool = false

func set_data(data: Crop) -> void:
	crop_data = data

func spawn_physical_crop(grow_index: int) -> void:
	if grow_index < crop_data.grow_meshes.size():
		if static_body != null:
			static_body.call_deferred("queue_free")
		
		_spawn_with_static_body(crop_data.grow_meshes[grow_index])
		
func fill_water() -> void:
	water_bar.value = water_bar.max_value
		
		
func reduce_water(current_water: float) -> void:
	water_bar.value = current_water
	
func set_timer(current_time: float) -> void:
	@warning_ignore("integer_division")
	var minute: int = int(current_time) / 60
	var second: int = int(current_time) % 60
	var second_string: String
	if second < 10:
		second_string = "0" + str(second)
	else:
		second_string = str(second)
	
	grow_time.text = str(minute) + ":" + second_string
	
func modulate_red(red: bool) -> void:
	if red:
		canvas_modulate.color = Color("ff00ffff")
	else:
		canvas_modulate.color = Color("ffffff")
	
	
func allow_harvest() -> void: 
	bt_player.call_deferred("queue_free")
	gui_3d_visualizer.call_deferred("queue_free")
	
	static_body.set_collision_mask_value(3, true)
	static_body.set_collision_layer_value(3, true)
	static_body.set_collision_mask_value(1, false)
	static_body.set_collision_layer_value(1, false)
	static_body.set_collision_mask_value(2, true)
	static_body.set_collision_layer_value(2, true)
	
	
	
func harvest() -> Crop:
	if !animation_player.is_playing():
		animation_player.play("harvest")
		Dynamic.total_money += 3
		return crop_data
	else:
		return null


func _spawn_with_static_body(packed_scene) -> void:
	physical_crop = packed_scene.instantiate() as Node3D

	var mesh_instance = Kinetic.find_first_mesh_instance(physical_crop)
	if mesh_instance and mesh_instance.mesh:
		static_body = StaticBody3D.new()
		var shape = mesh_instance.mesh.create_convex_shape()
		var col_shape = CollisionShape3D.new()
		col_shape.shape = shape

		self.add_child(static_body)
		static_body.add_child(physical_crop)
		static_body.add_child(col_shape)
		col_shape.global_position = mesh_instance.global_position
