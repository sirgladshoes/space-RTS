extends action

@export var ship = preload("res://units/controllable_units/basic_ship.tscn")
@export var cost = {
	asteroid.types.GOLD : 10, asteroid.types.CURRENCY : 0, asteroid.types.GNOME_FLESH : 0
}

func execute():
	if Network2.is_server:
		make_ship()
	elif conditions_met(owner.inventory[0], owner.inventory[2], owner.inventory[1]):
		owner.inventory[0] -= gold_cost
		owner.inventory[2] -= gnome_flesh_cost
		owner.inventory[1] -= credits_cost
		Network2.push_ship_command(owner.name, ["action", name])
	
func make_ship():
	print("make")
	print(conditions_met(owner.inventory[0], owner.inventory[2], owner.inventory[1]))
	if conditions_met(owner.inventory[0], owner.inventory[2], owner.inventory[1]):
		print(owner)
		owner.inventory[0] -= gold_cost
		owner.inventory[2] -= gnome_flesh_cost
		owner.inventory[1] -= credits_cost
		var ship_obj = ship.instantiate()
		ship_obj.global_position = owner.global_position
		ship_obj.team = owner.team
		SceneManager.scene_root.add_child(ship_obj, true)
