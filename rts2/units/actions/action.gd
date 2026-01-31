extends Node

class_name action

@export var texture: Texture2D
@export var timer_length: float
@export var gnome_flesh_cost:int
@export var gold_cost: int
@export var credits_cost:int

var timer: float = 0

func _ready():
	owner = get_parent().get_parent()

func _process(delta):
	if(timer > 0):
		timer -= delta
	elif(timer < 0):
		timer = 0

func execute():
	print("were doing it")

func conditions_met(gold, gnome_flesh, credits):
	if (gnome_flesh_cost <= gnome_flesh && gold_cost <= gold && credits_cost <= credits):
		return true
	else:
		return false
