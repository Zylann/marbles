extends RigidBody


func _process(delta):
	if translation.y < -100:
		print("Marble is too low, freeing")
		queue_free()

