extends Node2D

var rigidbodies

@export var force = 30

# Called when the node enters the scene tree for the first time.
func _ready():
	rigidbodies = get_children()
	explode()
	await get_tree().create_timer(2).timeout
	get_tree().quit()

func explode():
	for body in rigidbodies:
		body.angular_velocity = (randf() - .5)
		body.apply_central_force(Vector2(body.get_node("center").position.x * force * -1, body.get_node("center").position.y * force))
