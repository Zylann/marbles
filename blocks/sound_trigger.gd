extends Area


onready var _player = get_node("Sound")


func _on_SoundTrigger_body_entered(body):
	if body.is_in_group("marbles"):
		_player.play()


