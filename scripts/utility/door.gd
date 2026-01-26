extends MeshInstance3D

@export var go_outside: bool = false
@export var outdoor_sounds: AudioStreamPlayer

@onready var marker_3d: Marker3D = $Marker3D
@onready var player: Player = get_tree().get_first_node_in_group("Player")

func on_click() -> void:
	player.global_position = marker_3d.global_position
	$DoorSound.play(0.07)
	
	if go_outside:
		outdoor_sounds.play()
	else:
		outdoor_sounds.stop()
