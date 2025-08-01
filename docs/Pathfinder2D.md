## Pathfinder2D

**Inherits:** [Node](https://docs.godotengine.org/en/stable/classes/class_node.html) < [Object](https://docs.godotengine.org/en/stable/classes/class_object.html#class-object)

### Description

A 2D pathfinder used to navigate to a position while avoiding static obstacles. The calculation can be used by the parent 2D node to dynamically move it along the path.

After setting the `pathfinding_map` and `target_position` properties, the `get_next_path_position()` method must be used to obtain the next movement position for the parent node.

### Properties

| Type | Property | Default | Description |
|------|----------|---------|-------------|
| [`float`](https://docs.godotengine.org/en/stable/classes/class_float.html) | `target_desired_distance` | `10.0` | Distance from the target at which the pathfinder considers the destination reached. |
| [`AStarGrid2D.DiagonalMode`](https://docs.godotengine.org/en/stable/classes/class_astargrid2d.html#enum-astargrid2d-diagonalmode) | `diagonal_mode` | `0` | Diagonal movement setting used for pathfinding. |
| [`AStarGrid2D.Heuristic`](https://docs.godotengine.org/en/stable/classes/class_astargrid2d.html#enum-astargrid2d-heuristic) | `heuristic` | `0` | Heuristic algorithm used to estimate distance to the goal. |
| [`bool`](https://docs.godotengine.org/en/stable/classes/class_bool.html) | `allow_partial_path` | `true` | Allows returning a partial path if a full path cannot be found. |
| [`bool`](https://docs.godotengine.org/en/stable/classes/class_bool.html) | `simplify_path` | `false` | Simplifies the path by removing unnecessary points. |
| [`bool`](https://docs.godotengine.org/en/stable/classes/class_bool.html) | `debug_enabled` | `false` | Enables debug visualization of the path. |
| [`Color`](https://docs.godotengine.org/en/stable/classes/class_color.html) | `path_line_color` | `Color(1, 0, 0, 1)` | Color of the path line when debug is enabled. |
| [`float`](https://docs.godotengine.org/en/stable/classes/class_float.html) | `path_line_width` | `1.0` | Width of the path line in debug mode. |
| [`PathfindingMap`](PathfindingMap.md) | `pathfinding_map` | `null` | Reference to the map used for pathfinding. |
| [`Vector2`](https://docs.godotengine.org/en/stable/classes/class_vector2.html) | `target_position` | `Vector2(0, 0)` | The target position for the pathfinder. |

### Methods

| Return Type | Method | Description |
|-------------|--------|-------------|
| [`Vector2`](https://docs.godotengine.org/en/stable/classes/class_vector2.html) | `get_next_path_position()` | Returns the next position along the calculated path.  If the pathfinder does not have a path, it will return the position of the pathfinder's parent. |
| [`Array`](https://docs.godotengine.org/en/stable/classes/class_array.html)[[`Vector2i`](https://docs.godotengine.org/en/stable/classes/class_vector2i.html)] | `get_path_points()` | Returns the path as an array of points. |
| [`Array`](https://docs.godotengine.org/en/stable/classes/class_array.html)[[`Vector2`](https://docs.godotengine.org/en/stable/classes/class_vector2.html)] | `get_path_positions(from: int = 0)` | Returns the path as an array of world positions. Optionally, specify the index of a path point to start returning positions from. Returns an empty array if `from` is out of bounds. |
| [`bool`](https://docs.godotengine.org/en/stable/classes/class_bool.html) | `is_target_reached()` | Returns `true` if the pathfinder's parent has reached its destination. |

### Signals

| Signal | Description |
|--------|-------------|
| `target_reached()` | Emitted when the pathfinder's parent reached the target, i.e. the parent moved within `target_desired_distance` of the `target_position`. This signal is emitted only once per found path. |
| `map_changed()` | Emitted when the pathfinding map has been changed. |

