extends Node2D

var select_origin = null
@export var selection_mask = 1

#@onready var UI: CanvasLayer = get_node("Ui")

var selected_units = []

var has_been_released: bool

signal show_toolbar()
signal hide_toolbar()
signal update_toolbar(data)

func _ready():
	Network2.connect("on_client_sent_ship_command", sent_ship_command)

func sent_ship_command(ship, command):
	if SceneManager.scene_root.has_node(str(ship)):
		var ship_ = SceneManager.scene_root.get_node(str(ship))
		match command[0]:
			"move":
				ship_.set_movement_dir(command[1])
			"stop":
				ship_.set_movement_dir(Vector2.ZERO)
			"set_mode":
				ship_.set_mode(command[1])
			"action":
				ship_.get_node("actions").get_node(str(command[1])).execute()

func _process(delta):
	has_been_released = false
	for unit in selected_units:
		if unit == null:
			selected_units.erase(unit)
	if Input.is_action_just_pressed("select"):
		if !(selected_units and get_viewport().get_mouse_position().y <= get_viewport_rect().size.y * 8/72): 
			begin_select()
	if Input.is_action_pressed("select"):
		if select_origin != null:
			select_tick()
	if Input.is_action_just_released("select"):
		if select_origin != null:
			select_release()
	
	if Input.is_action_pressed("move_units"):
		move_units()
	if Input.is_action_just_pressed("stop_units"):
		stop_units()
		
	
	if selected_units:
		push_toolbar()

#func command_make():
#	if selected_units:
#		for unit in selected_units:
#			if unit.has_method("make_ship"):
#				unit.make_ship()

func begin_select():
	visible = true
	select_origin = get_global_mouse_position()

func select_tick():
	queue_redraw()

func select_release():
	has_been_released = true
	var select_position = get_global_mouse_position()
	var w = select_position.x-select_origin.x
	var h = select_position.y-select_origin.y
	
	var query = PhysicsShapeQueryParameters2D.new()
	var rect = RectangleShape2D.new()
	rect.extents = Vector2(abs(w)/2, abs(h)/2)
	query.set_shape(rect)
	query.transform = Transform2D(0, select_origin+Vector2(w,h)/2)
	query.collision_mask = selection_mask
	
	var space_state = get_world_2d().direct_space_state
	var result = space_state.intersect_shape(query)
	
	
	for unit in selected_units:
		unit.deselect()
	
	selected_units = []
	for target in result:
		if target["collider"] is unit and target.collider.team == owner.team:
			selected_units.append(target["collider"])
			target["collider"].select()
	
	select_origin = null
	visible = false
	
	if selected_units.size() > 0:
		show_toolbar.emit()
	else:
		hide_toolbar.emit()

func _draw():
	if select_origin:
		var select_position = get_global_mouse_position()
		var w = select_position.x-select_origin.x
		var h = select_position.y-select_origin.y
		draw_rect(Rect2(select_origin.x, select_origin.y, w, h), Color(1,1,1,1), false)


func move_units():
	
	#gets center of selected units
	var controllable_units = []
	var unit_position_sum = Vector2.ZERO
	for unit in selected_units:
		if unit is controllable_unit:
			unit_position_sum+= unit.global_position
			controllable_units.append(unit)
	var selected_center = unit_position_sum/controllable_units.size()
	
	var dir = selected_center.direction_to(get_global_mouse_position())
	for unit in controllable_units:
		if Network2.is_server:
			unit.set_movement_dir(dir)
		else:
			Network2.push_ship_command(unit.name, ["move", dir])
		

func stop_units():
	for unit in selected_units:
		if unit is controllable_unit:
			if Network2.is_server:
				unit.set_movement_dir(Vector2.ZERO)
			else:
				Network2.push_ship_command(unit.name, ["stop"])



func push_toolbar():
	var data = {}
	var currency = {asteroid.types.GOLD : 0, asteroid.types.CURRENCY : 0, asteroid.types.GNOME_FLESH : 0}
	data["modes"] = {"sentry":"", "mining":""}
	var sentry_count = 0
	var mining_count = 0
	for unit in selected_units:
		currency[asteroid.types.GNOME_FLESH] += unit.inventory[asteroid.types.GNOME_FLESH]
		currency[asteroid.types.GOLD] += unit.inventory[asteroid.types.GOLD]
		currency[asteroid.types.CURRENCY] += unit.inventory[asteroid.types.CURRENCY]
		if unit is controllable_unit :
			if unit.mode == controllable_unit.behaviour.SENTRY:
				sentry_count += 1
			if unit.mode == controllable_unit.behaviour.MINING:
				mining_count += 1
	
	data["currency"] = currency
	
	if sentry_count == selected_units.size():
		data.modes.sentry = "all"
	elif sentry_count == 0:
		data.modes.sentry = "none"
	else:
		data.modes.sentry = "some"
	
	if mining_count == selected_units.size():
		data.modes.mining = "all"
	elif mining_count == 0:
		data.modes.mining = "none"
	else:
		data.modes.mining = "some"
	
	data["ship_count"] = selected_units.size()
	if (selected_units.size() == 1):
		var action_nodes = selected_units[0].actions
		#var actions = []
		#for act in action_nodes:
			#actions.append({"gold": act.gold_cost, "gnome_flesh": act.gnome_flesh_cost, "credits": act.credits_cost, "timer": act.timer_length, "texture": act.texture})
		data["actions"] = action_nodes
	else:
		data["actions"] = null
		
	data["has_been_released"] = has_been_released
	update_toolbar.emit(data)


func _on_ui_set_mining():
	for unit in selected_units:
		if unit is controllable_unit:
			if Network2.is_server:
				unit.set_mode(controllable_unit.behaviour.MINING)
			else:
				Network2.push_ship_command(unit.name, ["set_mode", controllable_unit.behaviour.MINING])


func _on_ui_set_sentry():
	for unit in selected_units:
		if unit is controllable_unit:
			if Network2.is_server:
				unit.set_mode(controllable_unit.behaviour.SENTRY)
			else:
				Network2.push_ship_command(unit.name, ["set_mode", controllable_unit.behaviour.SENTRY])


func _on_ui_disable_mining():
	for unit in selected_units:
		if unit is controllable_unit and unit.mode == controllable_unit.behaviour.MINING:
			if Network2.is_server:
				unit.set_mode(controllable_unit.behaviour.NORMAL)
			else:
				Network2.push_ship_command(unit.name, ["set_mode", controllable_unit.behaviour.NORMAL])


func _on_ui_disable_sentries():
	for unit in selected_units:
		if unit is controllable_unit and unit.mode == controllable_unit.behaviour.SENTRY:
			if Network2.is_server:
				unit.set_mode(controllable_unit.behaviour.NORMAL)
			else:
				Network2.push_ship_command(unit.name, ["set_mode", controllable_unit.behaviour.NORMAL])

func execute_action(act:action):
	act.execute()
