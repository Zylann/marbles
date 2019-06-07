extends Spatial

onready var _camera = get_node("Camera")

var _target = null
var _prev_pos = Vector3()


func set_target(t):
	_target = t
	_target.hide()
	if _target != null:
		translation = _target.translation
	set_physics_process(_target != null)


func _physics_process(delta):
	if _target == null or (not is_instance_valid(_target)):
		print("No target")
		set_physics_process(false)
		return
	
	var pos = _target.translation
	var diff = pos - _prev_pos
	
	if diff == Vector3():
		print("Diff is zero")
		return
	
	translation = _prev_pos
	look_at(pos, Vector3.UP)
	print(_prev_pos)
	var avg = 4.0
	_prev_pos = (_prev_pos * (avg - 1.0) + pos) / avg

