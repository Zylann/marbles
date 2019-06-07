extends Spatial

const AVG_AMOUNT = 16

onready var _camera = get_node("Camera")

var _target = null
var _prev_pos = Vector3()
var _prev_up = Vector3(0, 1, 0)


func set_target(t):
	_target = t
	#_target.hide()
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
	
#	var state = get_viewport().world.direct_space_state
#	state.intersect_ray(pos, pos
	
	if diff == Vector3():
		print("Diff is zero")
		return
	
	translation = _prev_pos
	look_at(pos, _target.get_avg_ground_normal())
	var avg = float(AVG_AMOUNT)
	_prev_pos = (_prev_pos * (avg - 1.0) + pos) / avg

