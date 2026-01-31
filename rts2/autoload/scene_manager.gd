extends Node

#@onready var lobby_host_packed = preload("res://menus/lobby/lobby_host.tscn")
#@onready var lobby_client_packed = preload("res://menus/lobby/lobby_client.tscn")

@onready var game_host_packed = preload("res://host.tscn")
@onready var game_client_packed = preload("res://client.tscn")

@onready var ggs_packed = preload("res://win_screen.tscn")
@onready var unggs_packed = preload("res://lose_screen.tscn")

@onready var scene_root = get_tree().current_scene



#func switch_lobby():
	#var lobby
	#if Network.is_server:
		#lobby = lobby_host_packed.instantiate()
	#else:
		#lobby = lobby_client_packed.instantiate()
	#load_main(lobby)


func switch_host():
	var game_host = game_host_packed.instantiate()
	load_main(game_host)

func switch_client(ip):
	var game_client = game_client_packed.instantiate()
	game_client.ip = ip
	load_main(game_client)

func switch_game_over(win):
	var ggs
	if win:
		ggs = ggs_packed.instantiate()
	else:
		ggs = unggs_packed.instantiate()
	load_main(ggs)


func load_main(scene):
	unload_main()
	scene_root = scene
	get_tree().get_root().add_child(scene)

func unload_main():
	scene_root.queue_free()
