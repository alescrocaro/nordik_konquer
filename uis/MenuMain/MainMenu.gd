extends Control

func _on_play_pressed():
	get_tree().change_scene_to_file("res://world.tscn")
#end func _on_play_pressed


func _on_quit_pressed():
	get_tree().quit()
#end func _on_play_pressed


func _on_credits_pressed():
	get_tree().change_scene_to_file("res://uis/MenuCredits/CreditsMenu.tscn")
#end func _on_credits_pressed


func _on_instructions_pressed():
	get_tree().change_scene_to_file("res://uis/MenuInstructions/InstructionsMenu.tscn")
#end func _on_instructions_pressed
