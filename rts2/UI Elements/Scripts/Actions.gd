extends Control

@export var button_resource = preload("res://UI Elements/ActionButton.tscn")

var action_buttons = []

func add_buttons(data):
	action_buttons = []
	if data != null && data.size() > 0:
		for i in data.size():
			add_button(data[i])
	#print("signma")

func add_button(act):
	action_buttons.append(button_resource.instantiate())
	add_child(action_buttons[action_buttons.size() - 1])
	action_buttons[action_buttons.size() - 1].action_reference = act
	action_buttons[action_buttons.size() - 1].update_labels()
	action_buttons[action_buttons.size() - 1].position.x = (action_buttons.size() - 1) * 80
	#print("add")

func delete_children():
	for child in get_children():
		child.queue_free()
		#print("delete")
