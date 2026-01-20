extends Control

@export var book_entries: Array[Book] = []
@export var tea_entires: Array[BookOfTea] = []

@onready var book_list: ItemList = %BookList
@onready var tea_list: ItemList = %TeaList
@onready var paragraph_contents: VBoxContainer = %ParagraphContents
