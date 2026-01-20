extends LimboState

@onready var gaiwan_button: Button = %GaiwanButton
@onready var teapot_button: Button = %TeapotButton
@onready var heat_slider: VSlider = %HeatSlider
@onready var tea_container: ItemGrid = %TeaContainer
@onready var teacup_button: Button = %TeacupButton

var grid_teas: Array[Item] = []

func _enter() -> void:
	#State specific enabling
	gaiwan_button.button_up.connect(_on_button_down)
	gaiwan_button.disabled = false
	%TeaContainer.show()
	
	# Generic disables
	teacup_button.disabled = true
	teacup_button.disabled = true
	heat_slider.editable = false
	%SilderContainer.hide()
	
	# Fill grid with available teas
	grid_teas.clear()
	
	for i in len(agent.tea_base.tea_array):
		if Dynamic.unlocked_tea[i] != null:
			grid_teas.append(agent.tea_base.tea_array[i])
	
	tea_container.display(grid_teas)
	tea_container.activate_children(true)
	
	# Proceed to boil state
func _on_button_down() -> void:
	var held_item: DragItem = get_tree().get_first_node_in_group("DraggableItem") as DragItem
	if held_item:
		agent.current_tea = held_item.item_data
		Dynamic.tea_flavor = held_item.item_data.get_flavor_num()
		held_item.call_deferred("queue_free")
		get_root().dispatch("proceed_to_boil")
		
func _exit() -> void:
	#disable state specifics
	%TeaContainer.hide()
	tea_container.activate_children(false)
	gaiwan_button.disabled = true
	gaiwan_button.disconnect("button_up", _on_button_down)
