extends Camera2D

@export var speed = 200
var velocity = Vector2(0,0)


func _process(delta):
	#Checks if within y mouse move bounds
	var mouse_pos = get_viewport().get_mouse_position()
	var veiwport_size = get_viewport_rect().size
	if mouse_pos.y <= veiwport_size.y / 4:
		velocity.y = speed * (veiwport_size.y-mouse_pos.y - veiwport_size.y*(3.0/4.0))/(veiwport_size.y / 4)
	elif mouse_pos.y >= veiwport_size.y * (3.0/4.0):
		velocity.y = -speed * abs(veiwport_size.y*(3.0/4.0)-mouse_pos.y)/(veiwport_size.y/4)
	else:
		velocity.y = 0
	#Checks if within x mouse move bounds
	if mouse_pos.x <= veiwport_size.x / 8:
		velocity.x = speed * (veiwport_size.x-mouse_pos.x - veiwport_size.x*(7.0/8.0))/(veiwport_size.x / 8)
	elif mouse_pos.x >= veiwport_size.x * (7.0/8.0):
		velocity.x = -speed * abs(veiwport_size.x*(7.0/8.0)-mouse_pos.x)/(veiwport_size.x/8)
	else:
		velocity.x = 0
	position -= velocity*delta
	pass
