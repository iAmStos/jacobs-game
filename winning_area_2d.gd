extends Area2D

@onready var winning_spots = $"../WinningSpots"

func _ready() -> void:
	var random_win_spot = winning_spots.get_children().pick_random()
	self.global_position = random_win_spot.global_position


func _on_area_entered(area: Area2D):
	
	call_deferred("_change_scene")
	
func _change_scene():
	get_tree().change_scene_to_file("res://scenes/you_win.tscn")
