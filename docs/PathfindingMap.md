## PathfindingMap

**Inherits:** [RefCounted](https://docs.godotengine.org/en/stable/classes/class_refcounted.html#class-refcounted) < [Object](https://docs.godotengine.org/en/stable/classes/class_object.html#class-object)

### Description

PathfindingMap is a minimal, reference-counted class that stores essential information needed by [Pathfinder2D](Pathfinder2D.md) for grid-based A* pathfinding.

### Properties

| Type | Property | Default | Description |
|------|----------|---------|-------------|
| [`TileMapLayer`](https://docs.godotengine.org/en/stable/classes/class_tilemaplayer.html) | `layer` | *(none)* | The tilemap layer used as the source for pathfinding. |
| [`Vector2`](https://docs.godotengine.org/en/stable/classes/class_vector2.html) | `cell_size` | *(none)* | The size of each grid cell in world units. |
| [`Rect2i`](https://docs.godotengine.org/en/stable/classes/class_rect2i.html) | `region` | *(none)* | Corresponds to the [`region`](https://docs.godotengine.org/en/stable/classes/class_astargrid2d.html#class-astargrid2d-property-region) property of [`AStarGrid2D`](https://docs.godotengine.org/en/stable/classes/class_astargrid2d.html). |
| [`Array`](https://docs.godotengine.org/en/stable/classes/class_array.html)[[`Vector2i`](https://docs.godotengine.org/en/stable/classes/class_vector2i.html)] | `solid_cells` | `[]` | Array of coordinates representing non-walkable (solid) cells. |

