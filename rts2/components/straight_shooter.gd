extends Node2D

@export var distance = 500
@onready var team = owner.team
@export var shoot_interval = 0.5
@export var projectile: PackedScene
@export var animator: AnimationPlayer

func set_active(value):
	set_physics_process(value)
	$shoot_timer.stop()

func _physics_process(delta):
	var result = shoot_ray(global_position + distance*Vector2(cos(global_rotation), sin(global_rotation)))
	if result and result.obj is unit and result.obj.team != team:
		if $shoot_timer.is_stopped():
			$shoot_timer.start()
	else:
		$shoot_timer.stop()


func shoot_ray(target_: Vector2):
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(global_position, target_)
	query.collision_mask = 4
	var result = space_state.intersect_ray(query)
	if result:
		return null
	query.collision_mask = 1
	result = space_state.intersect_ray(query)
	if result:
		return {"obj": result.collider, "pos": result.position}
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
