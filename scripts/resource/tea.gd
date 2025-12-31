class_name Tea extends Item

@export_enum("Black", "Green", "Oolong") var tea_type: String
@export_range(0, 100, 5) var perfect_temp: float = 50
@export_range(0, 100, 5) var perfect_steep: float = 50
