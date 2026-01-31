extends Node2D


var team = unit.teams.TEAM1

# Called when the node enters the scene tree for the first time.
func _ready():
	Network2.begin_hosting(19204, 1)
	Network2.connect("on_client_connected", client_connected)

func client_connected(id):
	print(id)

func _physics_process(delta):
	Network2.push_game_state(compile_game_state())

func compile_game_state():
	var state = {}
	for networked in get_tree().get_nodes_in_group("networked"):
		if networked is unit:
			state[networked.name] = {"type":networked.networked_type,"pos":networked.global_position,"rot":networked.global_rotation ,"team":networked.team}
			if networked is controllable_unit:
				state[networked.name]["mode"] = networked.mode
		elif networked is asteroid:
			state[networked.name] = {"type":networked.networked_type,"pos":networked.global_position,"rot":networked.global_rotation}
	return state


func _on_mother_ggs(team_):
	if team_ == 1:
		Network2.push_game_end(0)
	else:
		Network2.push_game_end(1)
	if team != team_:
		SceneManager.switch_game_over(true)
	else:
		SceneManager.switch_game_over(false)
