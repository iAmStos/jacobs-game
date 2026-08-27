extends CharacterBody2D

var speed = 400  # speed in pixels/sec
var health = 4
var last_direction = Vector2.ZERO
@onready var bullet_manager: Node = get_parent().get_node("BulletManager")
@export var orb_scene : PackedScene
@export var bomb_scene : PackedScene
@export var energy : int = 5

@onready var health_bar = get_node("CanvasLayer/HBoxContainer/ChocyMilkBar")
@onready var energy_bar = get_node("CanvasLayer/HBoxContainer/Energy")

var choclate_milk_textures = [
	preload("res://Game art/most_broken.png"),
	preload("res://Game art/medium_broken.png"),
	preload("res://Game art/least_broken.png")
]

func _ready():
	update_health_bar()
	update_energy_bar()

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
		if energy > 0:
			energy -= 1
			shoot()
		update_energy_bar()
	if Input.is_action_just_pressed("bomb"):
		if energy >= 5:
			energy -= 5
			bomb()
		update_energy_bar()


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
	update_health_bar()


func _on_area_2d_area_entered(area: Area2D):
	if area.is_in_group("chocolate_milk"):
		if health < 4:
			health += 1
			area.queue_free()
			update_health_bar()
	if area.is_in_group("energy_drink"):
		if energy < 10:
			energy = min(energy + 5, 10)
			area.queue_free()
			update_energy_bar()

func update_health_bar():
	if health == 4:
		health_bar.texture_over = null
	elif health >= 1 and health <= 3:
		health_bar.texture_over = choclate_milk_textures[health - 1]
	else:
		health_bar.texture = null
	health_bar.value = health

func update_energy_bar():
	energy_bar.value = energy
