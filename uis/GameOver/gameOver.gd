extends Control

func _on_restart_pressed():
	get_tree().change_scene_to_file("res://world.tscn")
#end func _on_restart_pressed

func _on_go_to_menu_pressed():
	get_tree().change_scene_to_file("res://uis/MenuMain/MainMenu.tscn")
#end func _on_go_to_menu_pressed
