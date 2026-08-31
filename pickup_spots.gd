extends Node2D

var pickup_spots = []
@export var chocolate_milk_scene : PackedScene
@export var energy_drink_scene : PackedScene

func _ready():
	# Get all the pickup spots in the scene
	pickup_spots = get_children()
	pickup_spots.shuffle()
	var remove_count = pickup_spots.size() / 2
	for i in range(remove_count):
		var spot = pickup_spots.pop_back()
		spot.queue_free()  # Remove random half of the spots to avoid overlap

	# Spawn initial pickup
	for spot in pickup_spots:
		spawn_pickup(spot)


func spawn_pickup(spot: Node2D):
	if spot == null or spot.get_child_count() > 0:
		return  # Spot is null or already occupied

	if chocolate_milk_scene == null or energy_drink_scene == null:
		push_warning("Pickup scenes are not assigned in the Inspector.")
		return

	# Instantiate the random pickup
	var is_milk = randi() % 2 == 0  # Randomly decide between chocolate milk and energy drink
	var pickup_instance: Node2D
	if is_milk:
		pickup_instance = chocolate_milk_scene.instantiate()
	else:
		pickup_instance = energy_drink_scene.instantiate()

	# Place the pickup at the spot (Vector2.ZERO relative to the spot node)
	pickup_instance.position = Vector2.ZERO

	# Add the pickup instance to the spot node
	spot.add_child(pickup_instance)
