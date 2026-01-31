extends Node2D

@export var radius = 500
@onready var team = owner.team
@export var shoot_interval = 0.5
@export var projectile: PackedScene
@export var animator: AnimationPlayer

var target = null

func _physics_process(delta):
	if circle_cast(radius, global_position):
		var result = circle_cast(radius, global_position)
		var new_target = get_target(result)
		if new_target == null:
			$shoot_timer.stop()
			target = null
			return
		if new_target != target:
			if target == null:
				$shoot_timer.wait_time = shoot_interval
				$shoot_timer.start()
			target = new_target
		
		global_rotation = global_position.angle_to_point(target.global_position)


func circle_cast(radius: float, origin: Vector2):
	var query = PhysicsShapeQueryParameters2D.new()
	var circle = CircleShape2D.new()
	circle.radius = radius
	query.set_shape(circle)
	query.transform = Transform2D(0, origin)
	query.collision_mask = 1
	
	var space_state = get_world_2d().direct_space_state
	var result = space_state.intersect_shape(query)
	return result

func get_target(targets) -> Node2D:
	for target_ in targets:
		if target_["collider"] is unit and target_["collider"].team != team:
			return target_["collider"]
	return null

func shoot():
	var projectile_obj = projectile.instantiate()
	projectile_obj.global_position = global_position
	projectile_obj.global_rotation = global_rotation
	projectile_obj.team = team
	projectile_obj.damage = owner.damage
	SceneManager.scene_root.add_child(projectile_obj)
	if animator:
		animator.play("shoot")


func _on_shoot_timer_timeout():
	shoot()
	$shoot_timer.wait_time = shoot_interval
	$shoot_timer.start()
