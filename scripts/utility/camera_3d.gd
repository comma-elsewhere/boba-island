extends Camera3D

var shaker: ShakerComponent3D
var shaker_preset: ShakerPreset3D

func _ready() -> void:
	shaker = ShakerComponent3D.new()
	get_parent().add_child.call_deferred(shaker)
	shaker_preset = ShakerPreset3D.new()

func mutant_encounter(active: bool) -> void:
	if !active:
		await get_tree().create_timer(0.5).timeout
		shaker.shake(shaker_preset)
