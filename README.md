# Custom Pathfinding

Implementation of custom pathfinding system for Godot Engine 4.3+, based on the [A* algorithm](https://en.wikipedia.org/wiki/A*_search_algorithm) ([AStarGrid2D](https://docs.godotengine.org/en/stable/classes/class_astargrid2d.html)).

## How It Works

To add pathfinding functionality to an object of the [Node2D](https://docs.godotengine.org/en/stable/classes/class_node2d.html) class (or a class that inherits from it), you need to add a [Pathfinder2D](docs/Pathfinder2D.md) node to it as a child element. After that, you need to specify the map on which the route will be calculated ([PathfindingMap](docs/PathfindingMap.md)) and the final destination for [Pathfinder2D](docs/Pathfinder2D.md). If pathfinder receives all the necessary data in the specified order, it will find a route to the final destination, which can be obtained through special functions: `get_path_coords()`, `get_path_positions()`, `get_next_path_position()`.

**Example**

Setting up PathfindingMap for [Pathfinder2D](docs/Pathfinder2D.md) of an enemy character from the game level code:
```GDScript
func _ready() -> void:
	# Set the pathfinding map for Pathfinder2D.
	$EnemyCharacter.pathfinder.pathdinding_map = PathfindingMap.new($TileMapLayers/GroundLayer, __get_impassable_cells())
	return
```

Setting the final destination for [Pathfinder2D](docs/Pathfinder2D.md) (updated every physical frame) in the enemy character's code:
```GDScript
func _physics_process(_delta: float) -> void:
	# Set the final destination for Pathfinder2D.
	pathfinder.target_position = movement_target.position
	# Move the character if the target is not reached.
	if not pathfinder.is_target_reached():
		velocity = __calculate_velocity()
		move_and_slide()
	return


func __calculate_velocity() -> Vector2:
	# Get direction to the nearest point from the found path.
	var direction : Vector2 = position.direction_to(pathfinder.get_next_path_position())
	if direction.length() > 1.0:
		direction = direction.normalized()
	return direction * speed
```

## Credits

This project uses custom node icons based on the open-source icon set from [Phosphor Icons](https://phosphoricons.com/).
> Phosphor is a flexible and open-source icon family for interfaces, diagrams, presentations — whatever, really.
> Licensed under the [MIT License](https://github.com/phosphor-icons/phosphor-home#license).

## License

This project is licensed under the [MIT License](https://github.com/ewylson/custom-pathfinding/blob/main/LICENSE).  
You are free to use, modify, and distribute it under the terms of that license.

