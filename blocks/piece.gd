extends StaticBody

const CollisionLayers = preload("res://collision_layers.gd")

const DefaultPieceMaterial = preload("res://blocks/default_piece_material.tres")
const DefaultGhostMaterial = preload("res://blocks/default_ghost_material.tres")

var _begin_area = null
var _end_area = null


func _ready():
	_begin_area = get_node("BeginArea")
	_end_area = get_node("EndArea")


func get_piece_index(piece_list):
	for i in len(piece_list):
		var piece = piece_list[i]
		if piece.resource_path == filename:
			return i
	return -1


func set_ghost(is_ghost):
	var mat
	
	if is_ghost:
		mat = DefaultGhostMaterial
		collision_layer = 0
		_begin_area.collision_layer = 0
		_end_area.collision_layer = 0
		if is_in_group("pieces"):
			remove_from_group("pieces")
	
	else:
		mat = DefaultPieceMaterial
		collision_layer = 1 << CollisionLayers.PROPS
		_begin_area.collision_layer = 1 << CollisionLayers.CONNECTION_AREAS
		_end_area.collision_layer = 1 << CollisionLayers.CONNECTION_AREAS
		if not is_in_group("pieces"):
			add_to_group("pieces")
	
	for i in get_child_count():
		var child = get_child(i)
		if child is MeshInstance:
			child.material_override = mat


func get_begin():
	return _begin_area


func get_end():
	return _end_area
