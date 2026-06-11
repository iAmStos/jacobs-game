extends CharacterBody2D

var speed = 400  # speed in pixels/sec

@onready var bullet_manager: Node = get_parent().get_node("BulletManager")
@export var orb_scene : PackedScene

func _physics_process(delta):
    var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
    velocity = direction * speed

    move_and_slide()

    if Input.is_action_just_pressed("shoot"):
        shoot()

func shoot():
    var bullet_instance = orb_scene.instantiate()
    bullet_instance.position = global_position
    bullet_instance.rotation = velocity.angle()
    bullet_manager.add_child(bullet_instance)