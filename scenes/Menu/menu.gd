extends Node2D


func _on_info_pressed() -> void:
	# ustawiamy pozycję popupu
	$InstructionsDialog.popup()  # standardowe otwarcie
	$InstructionsDialog.position = Vector2(500, 600)         # otwiera AcceptDialog


func _on_start_pressed() -> void:
	
	var new_scene = load("res://scenes/Cave/Cave.tscn") as PackedScene
	if new_scene:
		print("Scene loaded: Cave")
		get_tree().change_scene_to_packed(new_scene)
	else:
		print("Failed to load: Cave")
