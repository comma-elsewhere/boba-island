class_name OrderGen

const WANT := ["I want a ", "Can I get a ", "Could I have a ", "May I please get a ", "Give me a "]
const THAT := " that "
const AND := " and also "

const PLAIN_TEA := "drink"
const BOBA_TEA := "boba"
const MILK_TEA := "milk tea"
const MILK_BOBA := "boba milk"
const STRAWBERRY_MILK := "strawberry milk"
const STRAWBERRY_BOBA := "strawberry boba"

const GEN: Dictionary = {
	"KEY" : [
		["is for "],
		["is "],
		["reminds me of "],
		["has "],
		["is the color of "],
		["helps with "]
	],
	"ASSAM" : [
		["breakfast"],
		["invigorating", "strong"],
		["dark chocolate", "cereal"],
		["an earthy flavor"],
		["mahogany"],
		["digestion"]
	],
	"CEYLON" : [
		["energy"],
		["robust", "full-bodied"],
		["citrus", "warm spices"],
		["a smooth finish"],
		["copper and gold"],
		["tiredness"]
	],
	"CHAI" : [
		["relaxation"],
		["sweet and spicy", "comforting"],
		["autumn", "warm spices"],
		["a cozy smell"],
		["caramel"],
		["pain"]
	],
	"EARL_GREY" : [
		["inflammation"],
		["zesty", "floral"],
		["citrus", "fruit"],
		["a smoky flavor"],
		["dark amber"],
		["skin health"]
	],
	"HOJICHA" : [
		["mindfulness"],
		["earthy", "smooth"],
		["toasted rice", "roasted nuts"],
		["a smoky flavor"],
		["amber"],
		["anxiety"]
	],
	"JASMINE" : [
		["relaxation"],
		["floral", "calming"],
		["honey", "vanilla"],
		["a delicate flavor"],
		["pale gold"],
		["anxiety"]
	],
	"MINT" : [
		["the heat"],
		["balanced", "refreshing"],
		["candy canes", "summer"],
		["a cooling flavor"],
		["light green-gold"],
		["nausea"]
	],
	"SENCHA" : [
		["mindfulness"],
		["balanced", "vegetal"],
		["fresh greens", "a forest"],
		["a smooth finish"],
		["jade"],
		["focus"]
	],
	"OOLONG" : [
		[""],
		["nutty", "comforting"],
		["pastries", "honey"],
		["a complex flavor"],
		[""],
		[""]
	],
	"MATCHA" : [
		["energy"],
		["earthy", "balanced"],
		["fresh greens", "roasted nuts"],
		["a complex flavor"],
		["vivid emerald"],
		["focus"]
	],
	"TARO" : [
		[""],
		["", ""],
		["", ""],
		[""],
		[""],
		[""]
	],
}

func make_order(order: Drink) -> String:
	var flavor_key := _get_flavor(order.tea_flavor)
	var drink_type := _get_type(order.drink_type)
	var index_1 = [0,3,4,5].pick_random()
	var index_2 = [1,2].pick_random()
	return WANT.pick_random() + drink_type + THAT + GEN["KEY"][index_1][0] + GEN[flavor_key][index_1].pick_random() + AND + GEN["KEY"][index_2][0] + GEN[flavor_key][index_2].pick_random() + "."
	
func _get_type(drink_type: int) -> String:
	var type: String
	match drink_type:
		0: type = PLAIN_TEA
		1: type = BOBA_TEA
		2: type = MILK_TEA
		3: type = MILK_BOBA
		4: type = STRAWBERRY_MILK
		5: type = STRAWBERRY_BOBA
	return type
	
func _get_flavor(flavor_num: int) -> String:
	var flavor: String
	match flavor_num:
		Static.TEA.ASSAM:
			flavor = "ASSAM"
		Static.TEA.CEYLON:
			flavor = "CEYLON"
		Static.TEA.CHAI:
			flavor = "CHAI"
		Static.TEA.EARL_GREY:
			flavor = "EARL_GREY"
		Static.TEA.HOJICHA:
			flavor = "HOJICHA"
		Static.TEA.JASMINE:
			flavor = "JASMINE"
		Static.TEA.MINT:
			flavor = "MINT"
		Static.TEA.SENCHA:
			flavor = "SENCHA"
		Static.TEA.OOLONG:
			flavor = "OOLONG"
		Static.TEA.MATCHA:
			flavor = "MATCHA"
		Static.TEA.TARO:
			flavor = "TARO"
	return flavor
		
