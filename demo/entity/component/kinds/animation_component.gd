@icon("res://editor/icons/film-strip-fill.svg")
class_name AnimationComponent
extends EntityComponent


const RIGHT_Y_VELOCITY : float = 10.0


func _process(_delta: float) -> void:
	var velocity : Vector2 = owner_entity.velocity
	if velocity != Vector2.ZERO:
		if velocity.x != 0 and (velocity.y >= -RIGHT_Y_VELOCITY and velocity.y <= RIGHT_Y_VELOCITY):
			owner_entity.animation_player.play(&"look_right")
			owner_entity.sprite.flip_h = velocity.x < 0
		elif velocity.y < 0:
			owner_entity.animation_player.play(&"look_up")
			owner_entity.sprite.flip_h = false
		elif velocity.y > 0:
			owner_entity.animation_player.play(&"look_down")
			owner_entity.sprite.flip_h = false
	return
