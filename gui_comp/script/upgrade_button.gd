class_name UpgradeButton extends MenuButton

func _ready() -> void:
	disabled = true

func set_control_sibling(sibling: DebtStep) -> void:
	sibling.goal_maxed.connect(_self_activate)
	
func _self_activate(_node: DebtStep) -> void:
	disabled = false
