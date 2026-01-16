class_name Tea extends Item

@export_enum("Black", "Green", "Oolong") var tea_id: int = 0
@export_range(0, 100, 5) var perfect_temp: float = 50
@export_range(0, 100, 5) var perfect_time: float = 50

enum TOLERANCES {PERFECT = 5, AMAZING = 10, GREAT = 20, GOOD = 30, PASS = 40, FAIL = 50, BAD = 60, TERRIBLE = 80}
enum POINTS {PERFECT = 100, AMAZING = 90, GREAT = 80, GOOD = 70, PASS = 60, FAIL = 40, BAD = 20, TERRIBLE = 5}

func set_quality(temp: float, time: float) -> Array[int]:
	var diff_temp = perfect_temp - temp
	var diff_time = perfect_time - time
	
	quality = float(_get_points(absf(diff_temp)) + _get_points(absf(diff_time))) / 2 / 100
	quality = clampf(quality, 0, 1)
	print(quality)
	
	var results: Array[int] = []
	results.append(_high_or_low(diff_temp))
	results.append(_high_or_low(diff_time))
	return results
	
func get_flavor_num() -> int:
	if name == "Assam":
		return Static.TEA.ASSAM
	elif name == "Ceylon":
		return Static.TEA.CEYLON
	elif name == "Chai":
		return Static.TEA.CHAI
	elif name == "Earl Grey":
		return Static.TEA.EARL_GREY
	elif name == "Hojicha":
		return Static.TEA.HOJICHA
	elif name == "Jasmine":
		return Static.TEA.JASMINE
	elif name == "Moroccan Mint":
		return Static.TEA.MINT
	elif name == "Sencha":
		return Static.TEA.SENCHA
	elif name == "Oolong":
		return Static.TEA.OOLONG
	else: return 0
	
func _get_points(distance: float) -> int:
	if distance <= TOLERANCES.PERFECT:
		return POINTS.PERFECT
	elif distance <= TOLERANCES.AMAZING:
		return POINTS.AMAZING
	elif distance <= TOLERANCES.GREAT:
		return POINTS.GREAT
	elif distance <= TOLERANCES.GOOD:
		return POINTS.GOOD
	elif distance <= TOLERANCES.PASS:
		return POINTS.PASS
	elif distance <= TOLERANCES.FAIL:
		return POINTS.FAIL
	elif distance <= TOLERANCES.BAD:
		return POINTS.BAD
	elif distance <= TOLERANCES.TERRIBLE:
		return POINTS.TERRIBLE
	else: return 0

func _high_or_low(difference: float) -> int:
	if absf(difference) < TOLERANCES.AMAZING:
		return 0
	elif difference > 1:
		return -1
	else:
		return 1
