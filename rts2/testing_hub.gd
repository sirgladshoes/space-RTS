extends Node2D





func _on_button_2_pressed():
	SceneManager.switch_client($TextEdit.text)


func _on_button_pressed():
	SceneManager.switch_host()
