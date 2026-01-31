extends CharacterBody2D
class_name unit

enum teams {
	TEAM1, TEAM2
}

@export var team = teams.TEAM1
@export var health = 10
@export var mining_radius = 200
@export var networked_type = 1
@export var damage = 1

@onready var mining_laser_pckd = preload("res://components/mining_laser.tscn")

var inventory = {asteroid.types.GOLD : 0, asteroid.types.CURRENCY : 0, asteroid.types.GNOME_FLESH : 0}

var actions = []

signal dead()

func _ready():
	actions = get_action_nodes()
	if team != SceneManager.scene_root.team and has_node("MiniGuySelect"):
		$MiniGuySelect.material.set_shader_parameter("color", Vector3(1,0,0))

func select():
	if has_node("MiniGuySelect"):
		var color = $MiniGuySelect.material.get_shader_parameter("color")
		$MiniGuySelect.material.set_shader_parameter("color", Vector3(color.x, 0, color.y))

func deselect():
	if has_node("MiniGuySelect"):
		var color = $MiniGuySelect.material.get_shader_parameter("color")
		$MiniGuySelect.material.set_shader_parameter("color", Vector3(color.x, color.z, 0))

func take_damage(val):
	health -= val
	if health <= 0:
		dead.emit()
		queue_free()

#func get_target():
	#var query = PhysicsShapeQueryParameters2D.new()
	#var circle = CircleShape2D.new()
	#circle.radius = mining_radius
	#query.set_shape(circle)
	#query.transform = Transform2D(0, global_position)
	#query.collision_mask = 4
	#
	#var space_state = get_world_2d().direct_space_state
	#var result = space_state.intersect_shape(query)
	#print(result)
	#
	#if !result:
		#return null
	#return result[0]["collider"]

func mined_resource(type):
	# 0 = gold, 1 = currency, 2 = gnome flesh
	if type != 3:
		inventory[type] += 1

func get_action_nodes():
	if (get_node("actions") != null):
		return get_node("actions").get_children()
	else:
		push_warning("could not find actions node")
		return []

