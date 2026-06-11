extends Area2D

var speed = 750
var rotation_speed = 5
var sprite_node: Sprite2D

func _ready():
    sprite_node = $Sprite2D

func _physics_process(delta):
    position += transform.x * speed * delta
    sprite_node.rotation += rotation_speed * delta


func _on_body_entered(body: Node2D):
    if body.is_in_group("player"):
        return
    if body.has_method("take_damage"):
        body.take_damage(1)
    queue_free()
