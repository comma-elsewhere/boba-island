class_name Book extends Resource

@export_enum("OF_TEA", "BOBA_HISTORY", "CASSAVA_PROCESS", "MYTH", "UNYIELDY", "GONGFU", "CULT_FLYER", "CULT_DOCTRINE", "OLD_LETTER") var static_id: int = 0
@export var title: String
@export var content: Array[String] = []
