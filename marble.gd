extends RigidBody



func _ready():
	add_to_group("marbles")


func _process(delta):
	if translation.y < -100:
		print("Marble is too low, freeing")
		queue_free()

