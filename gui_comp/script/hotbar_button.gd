class_name HotbarButton extends TextureButton

var label: Label

func _ready() -> void:
	ignore_texture_size = true
	stretch_mode = TextureButton.STRETCH_KEEP_ASPECT_CENTERED
	custom_minimum_size = Vector2(100, 100)
	var panel = Panel.new()
	panel.set_anchors_preset(Control.PRESET_FULL_RECT)
	panel.show_behind_parent = true
	add_child(panel)
	label = Label.new()
	add_child(label)
	label.set_anchors_preset(Control.PRESET_CENTER_BOTTOM)
	label.custom_minimum_size = Vector2(100, 0)
	label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	label.text_overrun_behavior = TextServer.OVERRUN_TRIM_ELLIPSIS


func set_label(new_name: String) -> void:
	label.text = new_name
