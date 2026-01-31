extends unit

@export var radius = 1000

signal ggs(team)

func _process(delta):
	if circle_cast(radius, global_position) != []:
		pass

func circle_cast(radius: float, origin: Vector2):
	var query = PhysicsShapeQueryParameters2D.new()
	var circle = CircleShape2D.new()
	query.exclude = [self, asteroid]
	circle.radius = radius
	query.set_shape(circle)
	query.transform = Transform2D(0, origin)
	query.collision_mask = 1
	
	var space_state = get_world_2d().direct_space_state
	var result = space_state.intersect_shape(query)
	for i in result:
		if "inventory" in i.collider and i.collider.team == team:
			inventory[0] += i.collider.inventory[0]
			i.collider.inventory[0] = 0
			inventory[1] += i.collider.inventory[1]
			i.collider.inventory[1] = 0
			inventory[2] += i.collider.inventory[2]
			i.collider.inventory[2] = 0
	return result




func _on_dead():
	ggs.emit(team)
