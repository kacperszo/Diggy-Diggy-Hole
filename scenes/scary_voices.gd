extends AudioStreamPlayer2D


func _on_level_manager_change_volume(volume: int) -> void:
	self.volume_db = volume
	volume_db = volume
