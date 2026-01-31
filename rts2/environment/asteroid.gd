extends CharacterBody2D
class_name asteroid

enum types {
	GOLD, CURRENCY, GNOME_FLESH, NOTHING
}
@export var resource = types.NOTHING
@export var networked_type = 3

func _physics_process(delta):
	move_and_slide()
	velocity = velocity * 0.999

func _on_collider_body_entered(body):
	if "velocity" in body:
		velocity = body.velocity + velocity
		body.velocity = Vector2(0,0)
	else:
		velocity = velocity / -2
