class_name BookOfTea extends Book

@export_enum("ASSAM", "CEYLON", "CHAI", "EARL_GREY", "HOJICHA", "JASMINE", "MINT", "SENCHA", "OOLONG", "MATCHA", "TARO") var tea_type: int
@export_enum("long time/high temp", "long time/low temp", "short time/high temp", "short time/low temp", "very low temp", "very short time", "none") var brew_clue: int

const LABELS_NEEDED := 4

const LONG_HIGH := "This tea has a higher caffeine content, and flavors that take longer to develop."
const LONG_LOW := "This tea has delicate leaves, and flavors that take longer to develop."
const SHORT_HIGH := "This tea is prone to bitterness and has a higher caffeine content."
const SHORT_LOW := "This tea has delicate leaves and is prone to bitterness."
const VERY_LOW := "This tea's leaves are extremely sensitive to high temperatures."
const VERY_SHORT := "This tea can be very prone to bitterness when steeped too long."
const NONE := "This tea does not require brewing to make boba tea."

func get_brewing_clue() -> String:
	match brew_clue:
		0: return LONG_HIGH
		1: return LONG_LOW
		2: return SHORT_HIGH
		3: return SHORT_LOW
		4: return VERY_LOW
		5: return VERY_SHORT
		6: return NONE
	return NONE
