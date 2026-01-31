extends unit
class_name controllable_unit

@export var max_speed = 100
@export var thrust_speed = 100
@export var mining_lock_radius = 200
@export var sentry_lock_radius = 300

var target_vel = Vector2.ZERO
enum behaviour {
	SENTRY, MINING, NORMAL
}
var mode




func set_movement_dir(dir):
	if mode == behaviour.NORMAL:
		target_vel = dir*max_speed

func _ready():
	if team != SceneManager.scene_root.team:
		$MiniGuySelect.material.set_shader_parameter("color", Vector3(1,0,0))
	set_mode(behaviour.NORMAL)
	disable_mining()
	actions = get_action_nodes()

func _physics_process(delta):
	velocity = velocity.move_toward(target_vel, thrust_speed*delta)
	match mode:
		behaviour.NORMAL:
			normal_mode(delta)
		behaviour.MINING:
			mining_mode(delta)
		behaviour.SENTRY:
			sentry_mode(delta)
	move_and_slide()

func normal_mode(delta):
	if velocity != target_vel:
		rotation = rotate_toward(rotation, velocity.angle(), thrust_speed/15*delta)

func mining_mode(delta):
	var result = circle_cast(mining_lock_radius, global_position, 4)
	if result:
		var target = result[0]["collider"]
		if target is asteroid and target.resource != 3:
			var angle_sum = 0
			var angle_dir = 0
			#print(target.resource)
			if has_node("mining_lasers"):
				for laser in get_node("mining_lasers").get_children():
					angle_sum+=laser.rotation
				angle_dir = angle_sum/get_node("mining_lasers").get_children().size()
			rotation = rotate_toward(rotation, (target.global_position - global_position).angle()-angle_dir, thrust_speed/15*delta)

func sentry_mode(delta):
	var result = circle_cast(sentry_lock_radius, global_position, 1)
	var target = sentry_get_target(result)
	if target:
		var angle_sum = 0
		var angle_dir = 0
		if has_node("funny_gun"):
			for gun in get_node("funny_gun").get_children():
				angle_sum+=gun.rotation
			angle_dir = angle_sum/get_node("funny_gun").get_children().size()
		rotation = rotate_toward(rotation, (target.global_position - global_position).angle()-angle_dir, thrust_speed/15*delta)

func set_mode(mode_):
	if mode != mode_:
		match mode_:
			behaviour.NORMAL:
				disable_mining()
			behaviour.SENTRY:
				disable_mining()
				set_sentry_mode()
			behaviour.MINING:
				set_mining_mode()
		mode = mode_

func set_sentry_mode():
	set_movement_dir(Vector2(0,0))

func custom_sort(a, b):
	return global_position.direction_to(a.collider.global_position) > global_position.direction_to(b.collider.global_position)

func sentry_get_target(targets):
	for target in targets:
		if target["collider"] is unit and target["collider"].team != team:
			return target["collider"]
	return null

#mining functions
func set_mining_mode():
	set_movement_dir(Vector2(0,0))
	if has_node("mining_lasers"):
		for laser in get_node("mining_lasers").get_children():
			laser.set_active(true)

func disable_mining():
	if has_node("mining_lasers"):
		for laser in get_node("mining_lasers").get_children():
			laser.set_active(false)

func circle_cast(radius: float, origin: Vector2, layer: int):
	var query = PhysicsShapeQueryParameters2D.new()
	var circle = CircleShape2D.new()
	circle.radius = radius
	query.set_shape(circle)
	query.transform = Transform2D(0, origin)
	query.collision_mask = layer
	
	var space_state = get_world_2d().direct_space_state
	var result = space_state.intersect_shape(query)
	result.sort_custom(custom_sort)
	return result
