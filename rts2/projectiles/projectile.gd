extends Area2D
var velocity = Vector2(0,0)
var speed = 900
var damage
var team


func _ready():
	velocity = Vector2(cos(rotation), sin(rotation)) * speed


func _physics_process(delta):
	position += velocity*delta


func _on_body_entered(body):
	if body is unit and body.team != team:
		body.take_damage(damage)
		queue_free()
