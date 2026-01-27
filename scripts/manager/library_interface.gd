extends Control

@export var book_entries: Array[Book] = []
@export var tea_entries: Array[BookOfTea] = []

@onready var book_list: ItemList = %BookList
@onready var tea_list: ItemList = %TeaList
@onready var paragraph_contents: VBoxContainer = %ParagraphContents

const BOOK_OF_TEA := "The Book of Tea"
const FONT_SIZE := 20
const CUSTOM_MIN_SIZE := Vector2(460, 0)

func _ready() -> void:
	tea_list.hide()
	
	book_list.item_selected.connect(_select_book_entry)
	tea_list.item_selected.connect(_select_tea_entry)
	
	_fill_book_list()
	_fill_tea_list()
	
func reload() -> void:
	_reset_book_list()
	
func _reset_book_list() -> void:
	book_list.clear()
	tea_list.clear()
	_fill_book_list()
	_fill_tea_list()
	
func _select_book_entry(index: int) -> void:
	_clear_paragraph()
	if index > 0:
		tea_list.hide()
		var entry_data: Book = book_list.get_item_metadata(index) as Book
		_display_paragraph(_get_book_entry_contents(entry_data))
	else:
		tea_list.show()
	
func _select_tea_entry(index: int) -> void:
	var entry_data: BookOfTea = tea_list.get_item_metadata(index) as BookOfTea
	_clear_paragraph()
	_display_paragraph(_get_tea_entry_contents(entry_data))
	
func _fill_book_list() -> void:
	book_list.add_item(BOOK_OF_TEA)
	
	var index = 1
	for i in range(Static.NUMBER_OF_BOOKS):
		if Dynamic.unlocked_book[i] != null:
			var book = book_entries[i]
			book_list.add_item(book.title)
			book_list.set_item_metadata(index, book)
			index += 1
	
func _fill_tea_list():
	var index = 0
	for i in range(Static.NUMBER_OF_TEAS):
		if Dynamic.unlocked_tea[i] != null:
			var tea = tea_entries[i]
			tea_list.add_item(tea.title)
			tea_list.set_item_metadata(index, tea)
			index += 1
	
func _display_paragraph(book_contents: Array[String]) -> void:
	for i in len(book_contents):
		var new_label = Label.new()
		new_label.add_theme_font_size_override("font_size", FONT_SIZE)
		new_label.custom_minimum_size = CUSTOM_MIN_SIZE
		new_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
		new_label.text = book_contents[i]
		paragraph_contents.add_child(new_label)
	
func _clear_paragraph() -> void:
	for child in paragraph_contents.get_children():
		child.queue_free()
	
func _get_book_entry_contents(book_entry: Book) -> Array[String]:
	var string_array = book_entry.content.duplicate()
	string_array.push_front(book_entry.title)
	return string_array
	
func _get_tea_entry_contents(book_entry: BookOfTea) -> Array[String]:
	var string_array = book_entry.content.duplicate()
	string_array.push_front(book_entry.title)
	string_array.push_back(book_entry.get_brewing_clue())
	return string_array
