extends Node2D

var ip = null
var team = unit.teams.TEAM2

@onready var networked_type_1 = preload("res://units/controllable_units/basic_ship.tscn")
@onready var networked_type_2 = preload("res://units/controllable_units/ship_2.tscn")
@onready var networked_type_3 = preload("res://environment/asteroid.tscn")
@onready var networked_type_4 = preload("res://environment/asteroid_gold.tscn")
@onready var networked_type_5 = preload("res://environment/asteroid_currency.tscn")
@onready var networked_type_6 = preload("res://environment/asteroid_gnome_flesh.tscn")
@onready var networked_type_7 = preload("res://units/maker_node.tscn")
@onready var networked_type_8 = preload("res://units/mother.tscn")
@onready var networked_type_9 = preload("res://units/controllable_units/ship_3.tscn")
@onready var networked_type_10 = preload("res://units/controllable_units/mining_ship.tscn")
@onready var networked_type_11 = preload("res://units/controllable_units/ship_4.tscn")

func _ready():
	Network2.begin_join_server(ip, 19204)
	Network2.connect("on_connected_to_server", on_join)
	Network2.connect("on_host_sent_game_state", on_recieve_game_state)
	Network2.connect("on_host_sent_game_end", game_ended)

func on_join():
	print("join")

func game_ended(winner):
	if winner == team:
		SceneManager.switch_game_over(true)
	else:
		SceneManager.switch_game_over(false)

func on_recieve_game_state(state):
	var game_root = SceneManager.scene_root
	for networked in state:
		if !game_root.has_node(networked):
			var entity_state = state[networked]
			var networked_entity = get("networked_type_" + str(entity_state.type)).instantiate()
			networked_entity.name = networked
			sync_entity_state(networked_entity, entity_state)
			game_root.add_child(networked_entity)
		else:
			var entity = game_root.get_node(networked)
			sync_entity_state(entity, state[networked])
	
	for node in get_tree().get_nodes_in_group("networked"):
		if !state.keys().has(node.name):
			node.queue_free()

func sync_entity_state(entity, state):
	entity.global_position = state.pos
	entity.global_rotation = state.rot
	if entity is unit:
		entity.team = state.team
		if entity is controllable_unit:
			entity.set_mode(state.mode)
