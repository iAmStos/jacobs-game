extends Area2D

var speed = 750
var rotation_speed = 5
var sprite_node: Sprite2D

func _ready():
	sprite_node = $Sprite2D
	fade_out()

func fade_out():
	# Create the tween
	var tween = create_tween()
	
	# Animate the alpha (transparency) from 1.0 (fully visible) to 0.0 (invisible)
	tween.tween_property(self, "modulate:a", 0.0, 1.0)
	
	# Optional: Free the sprite from memory once the fade finishes
	await tween.finished
	queue_free()

func _on_body_entered(body: Node2D):
	if body.is_in_group("player"):
		return
	if body.has_method("take_damage"):
		body.take_damage(1)
