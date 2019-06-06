extends Node

const CollisionLayers = preload("res://collision_layers.gd")

onready var _machine = get_parent().get_parent()
onready var _camera = get_parent().get_node("Camera")

var _ghost = null
var _current_piece_index = 0
var _overlapping_pieces = []
var _floor_height = 0

var _pieces_library = [
	load("res://blocks/forward_down.tscn")
]


func _ready():
	call_deferred("set_current_piece", 0)


func set_current_piece(i):
	_current_piece_index = i
	var piece = _pieces_library[_current_piece_index]
	if _ghost != null:
		_ghost.queue_free()
	_ghost = piece.instance()
	_machine.add_child(_ghost)
	_ghost.set_ghost(true)


func place_piece():
	_ghost.set_ghost(false)
	
	var piece = _pieces_library[_current_piece_index]
	_ghost = piece.instance()
	_machine.add_child(_ghost)
	_ghost.set_ghost(true)


func erase_piece():
	for piece in _overlapping_pieces:
		piece.queue_free()


func _physics_process(delta):
	if _ghost == null:
		return
	
	var state = get_viewport().world.direct_space_state
	var q = PhysicsShapeQueryParameters.new()
	var shape = BoxShape.new()
	shape.extents = Vector3(1,1,1) * 0.4
	q.set_shape(shape)
	q.transform = Transform(Basis(), _ghost.translation)
	q.collide_with_areas = false
	var hits = state.intersect_shape(q)
	
	_overlapping_pieces.clear()
	for hit in hits:
		_overlapping_pieces.append(hit.collider)
	
	var mpos = get_viewport().get_mouse_position()
	var ray_origin = _camera.project_ray_origin(mpos)
	var ray_direction = _camera.project_ray_normal(mpos)
	var hit = state.intersect_ray(ray_origin, ray_origin + ray_direction * 50.0, [], \
		1 << CollisionLayers.CONNECTION_AREAS, false, true)
	
	if not hit.empty():
		var con_pos = hit.collider.global_transform.origin
		var is_begin = hit.collider.name.find("Begin") != -1
		var offset = Vector3()
		var con
		if is_begin:
			con = _ghost.get_end()
			offset = _ghost.global_transform.origin - con.global_transform.origin
		else:
			con = _ghost.get_begin()
			offset = _ghost.global_transform.origin - con.global_transform.origin
		_ghost.translation = con_pos + offset
	
	else:
		_ghost.translation = ray_origin + ray_direction * 5.0


func _input(event):
	if event is InputEventMouseButton:
		if event.pressed:
			if event.button_index == BUTTON_LEFT:
				if len(_overlapping_pieces) == 0:
					place_piece()
				else:
					print(len(_overlapping_pieces), " pieces are overlapping")
			
			elif event.button_index == BUTTON_RIGHT:
				erase_piece()
	
	elif event is InputEventKey:
		if event.pressed:
			match event.scancode:
				KEY_SPACE:
					_ghost.rotate_y(PI / 2.0)
				KEY_UP:
					_floor_height += 1
				KEY_DOWN:
					_floor_height -= 1
				


