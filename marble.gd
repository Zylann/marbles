extends RigidBody

const AVG_AMOUNT = 5

var _ground_normal = Vector3.UP
var _avg_ground_normal = Vector3.UP


func _ready():
	add_to_group("marbles")


func get_avg_ground_normal():
	return _avg_ground_normal


func _process(delta):
	if translation.y < -100:
		print("Marble is too low, freeing")
		queue_free()


func _integrate_forces(state):
	if state.get_contact_count() > 0:
		var hit_pos = Vector3()
		for i in state.get_contact_count():
			hit_pos += state.get_contact_collider_position(i)
		hit_pos /= float(state.get_contact_count())
		var diff = state.transform.origin - hit_pos
		if diff != Vector3():
			_ground_normal = diff.normalize()
	else:
		_ground_normal = Vector3.UP

	var a = float(AVG_AMOUNT)
	_avg_ground_normal = (_avg_ground_normal * (a - 1) + _ground_normal) / a


