extends Control

@export var selectedGoldText:Label
@export var totalGoldText:Label
@export var selectedGnomeFleshText:Label
@export var totalGnomeFleshText:Label
@export var selectedCreditText:Label
@export var totalCreditText:Label

func update_currency(data):
	for currency in data:
		match currency:
			asteroid.types.GOLD:
				$Gold/NumberBackground/SelectedAmount.text = str(data[currency])
			asteroid.types.CURRENCY:
				$Credit/NumberBackground/SelectedAmount.text = str(data[currency])
			asteroid.types.GNOME_FLESH:
				$GnomeFlesh/NumberBackground/SelectedAmount.text = str(data[currency])
