extends Node3D

@export var weed_array: Array[PackedScene] = []
@export_range(0, 100, 1) var weed_density: float = 75

@onready var animation_player: AnimationPlayer = %AnimationPlayer


var weed: Node3D
var static_body: StaticBody3D
var alive: bool = false

func _ready() -> void:
	%Placeholder.queue_free()
	if _growth_odds():
		alive = true
		_grow_weed()

func harvest() -> Crop:
	if !animation_player.is_playing():
		animation_player.play("harvest")
	
	return null
		
func _growth_odds() -> bool:
	return randf_range(0, 100) < weed_density
	
func _grow_weed():
	if !weed_array.is_empty():
		var new_weed = weed_array.pick_random()
		weed = new_weed.instantiate() as Node3D
		add_child(weed)
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
