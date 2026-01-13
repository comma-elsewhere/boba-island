class_name NpcGen

const GREET = [
	"Hey, it's good to see you. ",
	"How's it going? ",
	"Wow, the farm looks great! ",
	"Man it's been a while, huh? ",
	"Hi, how've you been? "
	]
	
const BEGIN = [
	"Can I get the usual ",
	"Same as always, I'll have a ",
	"Could I get a ",
	"Hm, let's switch things up and do a ",
	"The usual please. "
]

const WITH = " with "

var DIALOGUE: Dictionary = {
	"NPC_1" = {
		"NAME" = "Frank",
		"ORDER" = preload("res://resources/game_data/drinks/plain_black.tres"),
		"TEA" = Static.TEA.ASSAM,
		"DIALOGUE" = [
			["This is my unique demo dialogue!", "I can say lots of things!", "I can go on and on, in fact..."],
			["Everytime I come here, I have different dialogue!", "Neato!"],
			["And when I run out of written dialogue, I'll auto-generate friendly orders...", "So I never run out of things to say!"]
		]
	},
	"NPC_2" = {
		"NAME" = "Mary",
		"ORDER" = preload("res://resources/game_data/drinks/plain_black.tres"),
		"TEA" = Static.TEA.OOLONG,
		"DIALOGUE" = [
			["Hi, this is demo dialogue.", "Named NPCs are regulars.", "We always order the name thing."],
			["Tourists are randomly generated", "The ratio of tourists to regulars can be changed"],
			["Tourist orders can be vague and confusingly worded.", "You might need to consult your notes.", "But regulars always know what they want."]
		]
	},
	"NPC_3" = {
		"NAME" = "Shelley",
		"ORDER" = preload("res://resources/game_data/drinks/plain_black.tres"),
		"TEA" = Static.TEA.SENCHA,
		"DIALOGUE" = [
			["Demo here, I'm dialogue.", "Prepare to be demo-ed."]
		]
	}
}

func get_name(customer_num: int) -> String:
	var customer_name: String = "Regular"
	match customer_num:
		1: customer_name = DIALOGUE.NPC_1.NAME
		2: customer_name = DIALOGUE.NPC_2.NAME
		3: customer_name = DIALOGUE.NPC_3.NAME
	return customer_name + ":"
	
func get_order(customer_num: int) -> Drink:
	var drink: Drink = null
	var tea: int
	match customer_num:
		1:
			drink = DIALOGUE.NPC_1.ORDER
			tea = DIALOGUE.NPC_1.TEA
		2:
			drink = DIALOGUE.NPC_2.ORDER
			tea = DIALOGUE.NPC_2.TEA
		3:
			drink = DIALOGUE.NPC_3.ORDER
			tea = DIALOGUE.NPC_3.TEA
	drink.set_tea_flavor(tea)
	return drink

func get_dialogue(customer_num: int) -> Array:
	var dialogue: Array
	match customer_num:
		1: dialogue = DIALOGUE.NPC_1.DIALOGUE
		2: dialogue = DIALOGUE.NPC_2.DIALOGUE
		3: dialogue = DIALOGUE.NPC_3.DIALOGUE
	if !dialogue.is_empty():
		return dialogue.pop_front()
	else:
		return []
		
func get_progress() -> Array[int]:
	var progress: Array[int] = []
	progress.append(DIALOGUE.NPC_1.DIALOGUE.size())
	progress.append(DIALOGUE.NPC_2.DIALOGUE.size())
	progress.append(DIALOGUE.NPC_3.DIALOGUE.size())
	
	return progress
	
func set_progress(saved_progress: Array[int]) -> void:
	var dialogue_array: Array[Array] = [DIALOGUE.NPC_1.DIALOGUE, DIALOGUE.NPC_2.DIALOGUE, DIALOGUE.NPC_3.DIALOGUE]
	for i in len(saved_progress):
		var resize_count := saved_progress[i]
		while resize_count > 0:
			dialogue_array[i].remove_at(0)
			resize_count -= 1

func generic_order(drink: Drink) -> String:
	return GREET.pick_random() + BEGIN.pick_random() + drink.name + WITH + _get_flavor(drink.tea_flavor)
	
func _get_flavor(flavor_num: int) -> String:
	var flavor: String
	match flavor_num:
		Static.TEA.ASSAM:
			flavor = "Assam black."
		Static.TEA.CEYLON:
			flavor = "Ceylon black."
		Static.TEA.CHAI:
			flavor = "Chai."
		Static.TEA.EARL_GREY:
			flavor = "Earl grey."
		Static.TEA.HOJICHA:
			flavor = "Hojicha green."
		Static.TEA.JASMINE:
			flavor = "Jasmine green."
		Static.TEA.MINT:
			flavor = "Morrocan Mint green."
		Static.TEA.SENCHA:
			flavor = "Sencha green."
		Static.TEA.OOLONG:
			flavor = "Oolong."
		Static.TEA.MATCHA:
			flavor = "Matcha."
		Static.TEA.TARO:
			flavor = "Taro."
	return flavor
