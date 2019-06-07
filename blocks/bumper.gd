extends Area


onready var _animation_player = get_parent().get_node("AnimationPlayer")


func _on_Area_body_entered(body):
	if body.is_in_group("marbles"):
		_animation_player.play("bump")
		body.apply_central_impulse(Vector3(0, 10, 0))

