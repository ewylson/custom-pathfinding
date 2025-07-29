# Custom Pathfinding

Implementation of custom pathfinding system for Godot Engine 4.3+, based on the [A* algorithm](https://en.wikipedia.org/wiki/A*_search_algorithm) ([AStarGrid2D](https://docs.godotengine.org/en/stable/classes/class_astargrid2d.html)).

## How It Works

To add pathfinding functionality to an object of the [Node2D](https://docs.godotengine.org/en/stable/classes/class_node2d.html) class (or a class that inherits from it), you need to add a [Pathfinder2D](https://github.com/ewylson/custom-pathfinding/new/main?filename=README.md#pathfinder2d) node to it as a child element. After that, you need to specify the map on which the route will be calculated (PathfindingMap) and the final destination for [Pathfinder2D](https://github.com/ewylson/custom-pathfinding/new/main?filename=README.md#pathfinder2d). If pathfinder receives all the necessary data in the specified order, it will find a route to the final destination, which can be obtained through special functions: `get_path_coords()`, `get_path_positions()`, `get_next_path_position()`.

**Example**

Setting up PathfindingMap for [Pathfinder2D](https://github.com/ewylson/custom-pathfinding/new/main?filename=README.md#pathfinder2d) of an enemy character from the game level code:
```GDScript
func _ready() -> void:
	# Set the pathfinding map for Pathfinder2D.
	$EnemyCharacter.pathfinder.pathdinding_map = PathfindingMap.new($TileMapLayers/GroundLayer, __get_impassable_cells())
	return
```

Setting the final destination for [Pathfinder2D](https://github.com/ewylson/custom-pathfinding/new/main?filename=README.md#pathfinder2d) (updated every physical frame) in the enemy character's code:
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

## Pathfinder2D

**Inherits:** [Node](https://docs.godotengine.org/en/stable/classes/class_node.html) < [Object](https://docs.godotengine.org/en/stable/classes/class_object.html#class-object)

### Description

A 2D pathfinder used to navigate to a position while avoiding static obstacles. The calculation can be used by the parent 2D node to dynamically move it along the path.

After setting the `pathfinding_map` and `target_position` properties, the `get_next_path_position()` method must be used to obtain the next movement position for the parent node.

### Properties

| Type | Property | Default | Description |
|------|----------|---------|-------------|
| [`float`](https://docs.godotengine.org/en/stable/classes/class_float.html) | `target_desired_distance` | `10.0` | Distance from the target at which the pathfinder considers the destination reached. |
| [`AStarGrid2D.DiagonalMode`](https://docs.godotengine.org/en/stable/classes/class_astargrid2d.html#enum-astargrid2d-diagonalmode) | `diagonal_mode` | *(none)* | Diagonal movement setting used for pathfinding. |
| [`AStarGrid2D.Heuristic`](https://docs.godotengine.org/en/stable/classes/class_astargrid2d.html#enum-astargrid2d-heuristic) | `heuristic` | *(none)* | Heuristic algorithm used to estimate distance to the goal. |
| [`bool`](https://docs.godotengine.org/en/stable/classes/class_bool.html) | `allow_partial_path` | `true` | Allows returning a partial path if a full path cannot be found. |
| [`bool`](https://docs.godotengine.org/en/stable/classes/class_bool.html) | `simplify_path` | `false` | Simplifies the path by removing unnecessary points. |
| [`bool`](https://docs.godotengine.org/en/stable/classes/class_bool.html) | `debug_enabled` | `false` | Enables debug visualization of the path. |
| [`Color`](https://docs.godotengine.org/en/stable/classes/class_color.html) | `path_line_color` | `Color.RED` | Color of the path line when debug is enabled. |
| [`float`](https://docs.godotengine.org/en/stable/classes/class_float.html) | `path_line_width` | `1.0` | Width of the path line in debug mode. |
| [`PathfindingMap`](https://docs.godotengine.org/en/stable/classes/class_object.html) | `pathfinding_map` | *(none)* | Reference to the map used for pathfinding. |
| [`Vector2`](https://docs.godotengine.org/en/stable/classes/class_vector2.html) | `target_position` | *(none)* | The target position for the pathfinder. |

### Methods

| Return Type | Method | Description |
|-------------|--------|-------------|
| [`Vector2`](https://docs.godotengine.org/en/stable/classes/class_vector2.html) | `get_next_path_position()` | Returns the next position along the calculated path. |
| [`Array`](https://docs.godotengine.org/en/stable/classes/class_array.html)[[`Vector2i`](https://docs.godotengine.org/en/stable/classes/class_vector2i.html)] | `get_path_coords()` | Returns the path as an array of grid coordinates. |
| [`Array`](https://docs.godotengine.org/en/stable/classes/class_array.html)[[`Vector2`](https://docs.godotengine.org/en/stable/classes/class_vector2.html)] | `get_path_positions()` | Returns the path as an array of world positions. |
| [`bool`](https://docs.godotengine.org/en/stable/classes/class_bool.html) | `is_target_reached()` | Returns `true` if the agent has reached its destination. |

### Signals

| Signal | Description |
|--------|-------------|
| `map_changed()` | Emitted when the pathfinding map has been changed. |

## PathfindingMap

**Inherits:** [RefCounted](https://docs.godotengine.org/en/stable/classes/class_refcounted.html#class-refcounted) < [Object](https://docs.godotengine.org/en/stable/classes/class_object.html#class-object)

### Description

PathfindingMap is a minimal, reference-counted class that stores essential information needed by [Pathfinder2D](https://github.com/ewylson/custom-pathfinding/new/main?filename=README.md#pathfinder2d) for grid-based A* pathfinding.

### Properties

| Type | Property | Default | Description |
|------|----------|---------|-------------|
| [`Vector2`](https://docs.godotengine.org/en/stable/classes/class_vector2.html) | `cell_size` | *(none)* | The size of each grid cell in world units. |
| [`TileMapLayer`](https://docs.godotengine.org/en/stable/classes/class_tilemaplayer.html) | `layer` | *(none)* | The tilemap layer used as the source for pathfinding. |
| [`Rect2i`](https://docs.godotengine.org/en/stable/classes/class_rect2i.html) | `region` | *(none)* | Corresponds to the [`region`](https://docs.godotengine.org/en/stable/classes/class_astargrid2d.html#class-astargrid2d-property-region) property of [`AStarGrid2D`](https://docs.godotengine.org/en/stable/classes/class_astargrid2d.html). |
| [`Array`](https://docs.godotengine.org/en/stable/classes/class_array.html)[[`Vector2i`](https://docs.godotengine.org/en/stable/classes/class_vector2i.html)] | `solid_cells` | `[]` | Array of coordinates representing non-walkable (solid) cells. |

