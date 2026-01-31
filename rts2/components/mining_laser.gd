extends Node2D


var target: Node2D = null
@export var distance = 200
@export var wait_time = 0.5
var resource

signal mined_resource(type)

func _ready():
	connect("mined_resource", owner.mined_resource)

func set_active(value):
	#print(value)
	set_physics_process(value)
	$mining_timer.stop()
	$line.visible = false
	target = null

func _physics_process(delta):
	var result = shoot_ray(global_position + distance*Vector2(cos(global_rotation), sin(global_rotation)))
	if result and result.obj is asteroid:
		if target != result.obj:
			$mining_timer.wait_time = wait_time
			$mining_timer.start()
			target = result.obj
			resource = result.obj.resource
		
		$line.visible = true
		var distance = (result.pos-global_position).length()
		$line.set_point_position(1, Vector2(distance, 0))
	else:
		target = null
		$mining_timer.stop()
		$line.visible = false



func shoot_ray(target_: Vector2):
	var space_state = get_world_2d().direct_space_state
	var query = PhysicsRayQueryParameters2D.create(global_position, target_)
	query.collision_mask = 4
	var result = space_state.intersect_ray(query)
	if result:
		return {"obj": result.collider, "pos": result.position}
	return null



func _on_mining_timer_timeout():
	print("I munt sigma gyatts")
	mined_resource.emit(resource)
