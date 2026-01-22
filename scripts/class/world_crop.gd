class_name WorldCrop extends Node3D

@export var crop_data: Crop

@onready var water_bar: TextureProgressBar = %WaterBar
@onready var grow_time: Label = %GrowTime
@onready var canvas_modulate: CanvasModulate = %CanvasModulate
@onready var water_visualizer: StaticBody3D = %WaterVisualizer
@onready var bt_player: BTPlayer = $BTPlayer
@onready var animation_player: AnimationPlayer = $AnimationPlayer

enum STATE {GROWING, CAN_HARVEST, HARVESTED}

var physical_crop: Node3D = null
var static_body: StaticBody3D = null

var mutated: bool = false
var crop_state: int

func _ready() -> void:
	crop_state = STATE.GROWING

func set_data(data: Crop) -> void:
	crop_data = data

func spawn_physical_crop(grow_index: int) -> void:
	if grow_index < crop_data.grow_meshes.size():
		if static_body != null:
			static_body.call_deferred("queue_free")
		
		_spawn_with_static_body(crop_data.grow_meshes[grow_index])
		
func on_click() -> void:
	water_bar.value = water_bar.max_value
		
func reduce_water(current_water: float) -> void:
	water_bar.value = current_water
	
func set_timer(current_time: float) -> void:
	@warning_ignore("integer_division")
	var minute: int = int(current_time) / 60
	var second: int = int(current_time) % 60
	grow_time.text = Kinetic.display_time(minute, second)
	
func modulate_red(red: bool) -> void:
	if red:
		canvas_modulate.color = Color("ff00ffff")
	else:
		canvas_modulate.color = Color("ffffff")
	
func allow_harvest() -> void: 
	crop_state = STATE.CAN_HARVEST
	if bt_player:
		bt_player.call_deferred("queue_free")
	if water_visualizer:
		water_visualizer.call_deferred("queue_free")
	
	static_body.set_collision_mask_value(3, true)
	static_body.set_collision_layer_value(3, true)
	static_body.set_collision_mask_value(1, false)
	static_body.set_collision_layer_value(1, false)
	static_body.set_collision_mask_value(2, true)
	static_body.set_collision_layer_value(2, true)

func harvest() -> Crop:
	if mutated:
		var mutation: CanvasLayer = crop_data.mutation_scene.instantiate() as CanvasLayer
		mutation.encounter_end.connect(_encounter_success)
		get_tree().current_scene.add_child(mutation)
		return null
		
	elif !animation_player.is_playing():
		crop_state = STATE.HARVESTED
		animation_player.play("harvest")
		return crop_data
	else: return null

func _spawn_with_static_body(packed_scene) -> void:
	physical_crop = packed_scene.instantiate() as Node3D
	var mesh_instance = Kinetic.find_first_mesh_instance(physical_crop)
	static_body = Kinetic.mesh_to_static_body(mesh_instance, self)
	add_child(physical_crop)
	static_body.scale = mesh_instance.scale
	static_body.global_position = mesh_instance.global_position
	physical_crop.reparent(static_body)

func _encounter_success(success: bool) -> void:
	if success:
		mutated = false
		spawn_physical_crop(crop_data.grow_meshes.size()-2)
		allow_harvest()
	else:
		crop_state = STATE.HARVESTED
		animation_player.play("harvest")
		

func on_save(save_data: Array[SavedData]) -> void:
	if crop_state != STATE.HARVESTED:
		var my_data = SavedCrop.new()
		my_data.position = global_position
		my_data.scene_file_path = scene_file_path
		my_data.mutated = mutated
		my_data.state = crop_state
		
		save_data.append(my_data)

func on_preload() -> void:
	get_parent().remove_child(self)
	queue_free()

func on_load(save_data: SavedData) -> void:
	var my_data: SavedCrop = save_data as SavedCrop
	global_position = my_data.position
	mutated = my_data.mutated
	crop_state = my_data.state
	
	if crop_state == STATE.CAN_HARVEST:
		if mutated:
			_spawn_with_static_body(crop_data.grow_meshes.size() - 1)
		else:
			_spawn_with_static_body(crop_data.grow_meshes.size() - 2)
		allow_harvest()
	else:
		return
	
