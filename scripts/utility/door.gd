extends MeshInstance3D

@onready var marker_3d: Marker3D = $Marker3D
@onready var player: Player = get_tree().get_first_node_in_group("Player")

func on_click() -> void:
	player.global_position = marker_3d.global_position
