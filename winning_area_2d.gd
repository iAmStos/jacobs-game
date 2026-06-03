extends Area2D


func _on_area_entered(area: Area2D):
    
    call_deferred("_change_scene")
	
func _change_scene():
    get_tree().change_scene_to_file("res://scenes/you_win.tscn")
