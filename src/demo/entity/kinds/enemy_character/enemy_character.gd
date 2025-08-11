@icon("res://editor/icons/2d/skull-fill.svg")
class_name EnemyCharacter
extends Entity


@export var movement_target : Node2D
@export_range(0.0, 300.0, 0.01, "or_greater", "suffix:px/s") var speed : float = 50.0


@onready var pathfinder : Pathfinder2D = $Pathfinder2D


func _physics_process(_delta: float) -> void:
	pathfinder.target_position = movement_target.position
	if not pathfinder.is_target_reached():
		velocity = __calculate_velocity()
		move_and_slide()
	return


func __calculate_velocity() -> Vector2:
	var direction : Vector2 = position.direction_to(pathfinder.get_next_path_position())
	if direction.length() > 1.0:
		direction = direction.normalized()
	return direction * speed
