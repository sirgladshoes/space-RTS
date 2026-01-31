extends CanvasLayer

@onready var ship_behaviors = $TopBar/TopPanel/Behaviors
@onready var currency = $TopBar/TopPanel/Currencies
@onready var actions = $TopBar/TopPanel/Actions

signal disable_mining()
signal disable_sentries()
signal set_mining()
signal set_sentry()

func update_toolbar(data):
	#print(data["currency"])
	ship_behaviors.update_sentry(data.modes.sentry)
	ship_behaviors.update_mining(data.modes.mining)
	currency.update_currency(data.currency)
	$TopBar/TopPanel/SelectionInfo/SelectedShips.text = str(data.ship_count) + " Ships Selected"
	if data.has_been_released:
		actions.delete_children()
		actions.add_buttons(data.actions)


func _on_command_manager_hide_toolbar():
	visible = false


func _on_command_manager_show_toolbar():
	visible = true


func _on_sentry_button_pressed():
	set_sentry.emit()



func _on_mining_button_pressed():
	set_mining.emit()



func _on_behaviors_set_sentry():
	set_sentry.emit()

func _on_behaviors_set_mining():
	set_mining.emit()

func _on_behaviors_disable_sentries():
	disable_sentries.emit()

func _on_behaviors_disable_mining():
	disable_mining.emit()
