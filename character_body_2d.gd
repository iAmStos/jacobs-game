extends CharacterBody2D

var speed = 400  # speed in pixels/sec
var health = 3
var last_direction = Vector2.ZERO
@onready var bullet_manager: Node = get_parent().get_node("BulletManager")
@export var orb_scene : PackedScene
@export var bomb_scene : PackedScene

func _physics_process(delta):
	var direction = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	if direction != Vector2.ZERO:
		last_direction = direction
	velocity = direction * speed
	if direction.y > 0:
		$AnimatedSprite2D.play("down")
	elif direction.y < 0:
		$AnimatedSprite2D.play("up")
	elif direction.x > 0:
		$AnimatedSprite2D.play("left")
	elif direction.x < 0:
		$AnimatedSprite2D.play("right")
	if direction == Vector2.ZERO:
		$AnimatedSprite2D.stop()
	move_and_slide()

	if Input.is_action_just_pressed("shoot"):
		shoot()
	if Input.is_action_just_pressed("bomb"):
		bomb()

func shoot():
	var mouse_position = get_global_mouse_position()
	var shoot_direction = (mouse_position - global_position).normalized()

	var bullet_instance = orb_scene.instantiate()
	bullet_instance.global_position = global_position
	bullet_instance.rotation = shoot_direction.angle()
	bullet_manager.add_child(bullet_instance)

func bomb():
	var bomb_instance = bomb_scene.instantiate()
	bomb_instance.position = global_position
	bullet_manager.add_child(bomb_instance)

func take_damage():
	health -= 1
	print(health)
	if health <=0:
		print("Die")
		get_tree().change_scene_to_file("res://scenes/you_lose.tscn")
