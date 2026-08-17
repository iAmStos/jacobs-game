extends CharacterBody2D

@export var speed: float = 120.0
@export var sight_collision_mask: int = 1
var health: int = 3

var nav_agent_node: NavigationAgent2D
var player_node: Node2D

var player_present = false

func _ready():
	nav_agent_node = $NavigationAgent2D
	_set_player_node()

func _physics_process(delta):
	
	
	if not is_instance_valid(player_node):
		_set_player_node()
		if not is_instance_valid(player_node):
			velocity = Vector2.ZERO
			move_and_slide()
			return

	if not can_see_player():
		if not player_present:
			velocity = Vector2.ZERO
			move_and_slide()
			return

	nav_agent_node.target_position = player_node.global_position

	if nav_agent_node.is_navigation_finished():
		velocity = Vector2.ZERO
	else:
		var next_path_position = nav_agent_node.get_next_path_position()
		var direction = global_position.direction_to(next_path_position)
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

func can_see_player() -> bool:
	if not is_instance_valid(player_node):
		return false

	var space_state := get_world_2d().direct_space_state
	var query := PhysicsRayQueryParameters2D.create(global_position, player_node.global_position)
	query.exclude = [self]
	query.collision_mask = sight_collision_mask

	var result := space_state.intersect_ray(query)
	if result.is_empty():
		return true

	return result.collider == player_node

func _set_player_node() -> void:
	if is_instance_valid(Globals.player_node):
		player_node = Globals.player_node
		return

	player_node = get_tree().get_root().find_child("Player", true, false) as Node2D

func take_damage(amount: int) -> void:
	health -= amount
	if health <= 0:
		queue_free()


func _on_area_2d_area_entered(area: Area2D) -> void:
	if area.get_parent().is_in_group("player"):
		area.get_parent().take_damage()
		self.queue_free()



func _on_detection_area_area_entered(area: Area2D) -> void:
	if area.is_in_group("player"):
		player_present = true


func _on_detection_area_area_exited(area: Area2D) -> void:
	if area.is_in_group("player"):
		player_present = false
