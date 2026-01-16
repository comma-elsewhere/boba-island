extends LimboHSM

@onready var select_state: LimboState = $SelectState
@onready var boil_state: LimboState = $BoilState
@onready var water_state: LimboState = $WaterState
@onready var can_brew_state: LimboState = $CanBrewState
@onready var brewing_state: LimboState = $BrewingState
@onready var tea_state: LimboState = $TeaState
