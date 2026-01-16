class_name GaiwanBowl extends MeshInstance3D

const LERP_RATE := 8.0

func set_with_flavor(tea_flavor: int) -> void:
	mesh.surface_get_material(2).albedo_color = Kinetic.get_tea_color(tea_flavor)

func set_empty() -> void:
	mesh.surface_get_material(2).albedo_color = Kinetic.get_tea_color(Static.TEA.EMPTY)
	
func set_water() -> void:
	mesh.surface_get_material(2).albedo_color = Kinetic.get_tea_color(Static.TEA.WATER)

func set_tea() -> void:
	mesh.surface_get_material(2).albedo_color = Kinetic.get_tea_color(Dynamic.tea_flavor)
