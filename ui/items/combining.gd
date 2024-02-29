class_name CombiningFeature
extends CanvasLayer
# Class for combining items in the inventory


@onready var item1 = $HBoxContainer/VBoxContainer/Item1
@onready var item2 = $HBoxContainer/VBoxContainer/Item2
@onready var item3 = $HBoxContainer/VBoxContainer/Item3
@onready var item4 = $HBoxContainer/VBoxContainer2/Item4
@onready var item5 = $HBoxContainer/VBoxContainer2/Item5
@onready var item6 = $HBoxContainer/VBoxContainer2/Item6
@onready var buttons = [item1, item2, item3, item4, item5, item6]

var selected: Array


func _ready():
	populate_inventory()
	item1.connect("button_down", add_selectable.bind(item1.text))
	item2.connect("button_down", add_selectable.bind(item2.text))
	item3.connect("button_down", add_selectable.bind(item3.text))
	item4.connect("button_down", add_selectable.bind(item4.text))
	item5.connect("button_down", add_selectable.bind(item5.text))
	item6.connect("button_down", add_selectable.bind(item6.text))


func _process(delta):
	for i in Items.items: #searches the items dictionary
		if sort_array(selected) == sort_array(Items.items[i]): #if the selected array equals one of the values for a key in dictionary (sorted so that order is irrelevant)
			for r in len(Items.inv): #searches the indexes of the inventory array
				if selected[0] == Items.inv[r]: #if the first value of selected is found
					Items.inv[r] = i #replace the value with the new item
				if selected[1] == Items.inv[r]: #if the second value of selected is found
					Items.inv[r] = "" #replace the value with empty
				populate_inventory()
				
			selected = []
			
	if selected.size() == 2:
		selected = []


func populate_inventory():
	var i = 0
	for t in buttons: #runs through every index in the buttons array
		if i < 6:
			t.text = Items.inv[i] #replace the text with the value of index of inventory
			i += 1 #add 1 to index to go to the next value


func sort_array(array: Array):
	array.sort()
	return array


func add_selectable(item):
	selected.append(item)
