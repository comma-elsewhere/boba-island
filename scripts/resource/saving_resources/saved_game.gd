class_name SavedGame extends Resource

@export var player_position: Vector3
@export var player_inventory: Array[Item] = []
@export var saved_data: Array[SavedData] = []

@export var options: Array[float] = []
@export var accessibility: Array[bool] = []
@export var progress: Array[Array] = []
@export var finances: Array[int] = []
@export var player_upgrades: Array = []
@export var recipe_upgrades: Array[int] = []
@export var difficulty: Array[int] = []
