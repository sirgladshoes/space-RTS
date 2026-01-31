extends Control

@onready var texture_rect = get_node("TextureRect")
@onready var texture_button = get_node("TextureButton")
@onready var gold_label = get_node("gold_label")
@onready var gnome_flesh_label = get_node("gnome_flesh_label")
@onready var credits_label = get_node("credits_label")
@onready var timer_label = get_node("timer_label")

var index = 0
var action_reference: action

@onready var command_manager = get_parent().get_parent().get_parent().get_parent().get_parent().get_node("command_manager")

signal execute_action

func update_labels():
	texture_rect.texture = action_reference.texture
	gold_label.text = str(action_reference.gold_cost) + " G"
	gnome_flesh_label.text = str(action_reference.gnome_flesh_cost) + " F"
	credits_label.text = str(action_reference.credits_cost)  + " C"
	timer_label.text = str(action_reference.timer_length) + " S"
	#execute_action.connect(action_reference.execute)
	
	execute_action.connect(command_manager.execute_action)

func _on_texture_button_pressed():
	execute_action.emit(action_reference)
	
	#execute_action.emit()
