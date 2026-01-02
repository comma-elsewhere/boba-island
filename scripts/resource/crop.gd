class_name Crop extends Item

@export var grow_meshes: Array[PackedScene]
@export var seed_price: int = 1
@export var grow_time: float = 5.0
@export_range(0,100) var water_max: int = 90
@export_range(0,100) var water_min: int = 10
@export_range(0.5,2.0,0.1) var mutation_mod: float = 1.0
