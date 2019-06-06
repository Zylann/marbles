extends StaticBody

const CollisionLayers = preload("res://collision_layers.gd")

const DefaultPieceMaterial = preload("res://blocks/default_piece_material.tres")
const DefaultGhostMaterial = preload("res://blocks/default_ghost_material.tres")

var _begin_area = null
var _end_area = null


func _ready():
	_begin_area = get_node("BeginArea")
	_end_area = get_node("EndArea")


func set_ghost(is_ghost):
	var mat
	
	if is_ghost:
		mat = DefaultGhostMaterial
		collision_layer = 0
		_begin_area.collision_layer = 0
		_end_area.collision_layer = 0
	
	else:
		mat = DefaultPieceMaterial
		collision_layer = CollisionLayers.PROPS
		_begin_area.collision_layer = 1 << CollisionLayers.CONNECTION_AREAS
		_end_area.collision_layer = 1 << CollisionLayers.CONNECTION_AREAS
	
	for i in get_child_count():
		var child = get_child(i)
		if child is MeshInstance:
			child.material_override = mat


func get_begin():
	return _begin_area


func get_end():
	return _end_area
