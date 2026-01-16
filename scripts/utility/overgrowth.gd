extends Node3D

@export var weed_array: Array[PackedScene] = []
@export_range(0, 100, 1) var weed_density: float = 75

@onready var animation_player: AnimationPlayer = %AnimationPlayer

var weed: Node3D
var static_body: StaticBody3D
var alive: bool = false
var weed_index: int

func _ready() -> void:
	if !_growth_odds():
		queue_free()
	
	elif !weed_array.is_empty():
		alive = true
		%Placeholder.queue_free()
		var new_weed = weed_array.pick_random()
		weed_index = weed_array.find(new_weed)
		weed = new_weed.instantiate() as Node3D
		_grow_weed()
	
func harvest() -> Crop:
	if !animation_player.is_playing():
		alive = false
		animation_player.play("harvest")
	return null
	
func _growth_odds() -> bool:
	return randf_range(0, 100) < weed_density
	
func _grow_weed():
	self.add_child(weed)
	var mesh_instance = Kinetic.find_first_mesh_instance(weed)
	static_body = Kinetic.mesh_to_static_body(mesh_instance, self)
	static_body.global_position = mesh_instance.global_position
	static_body.global_rotation = mesh_instance.global_rotation
	weed.reparent(static_body)
	
	static_body.set_collision_mask_value(3, true)
	static_body.set_collision_layer_value(3, true)
	static_body.set_collision_mask_value(1, false)
	static_body.set_collision_layer_value(1, false)
	static_body.set_collision_mask_value(2, true)
	static_body.set_collision_layer_value(2, true)


func on_save(save_data: Array[SavedData]) -> void:
	if !alive:
		return
	
	var my_data = SavedWeed.new()
	my_data.position = global_position
	my_data.scene_file_path = scene_file_path
	my_data.weed_index = weed_index
	
	save_data.append(my_data)

func on_preload() -> void:
	get_parent().remove_child(self)
	queue_free()

func on_load(save_data: SavedData) -> void:
	var my_data: SavedWeed = save_data as SavedWeed
	global_position = my_data.position
	weed_index = my_data.weed_index
	weed = weed_array[weed_index].instantiate() as Node3D
	call_deferred("_grow_weed")
