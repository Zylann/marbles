extends Node

const EditAvatarScene = preload("res://first_person_avatar.tscn")
const MarbleAvatarScene = preload("res://marble_camera.tscn")

const MODE_EDIT = 0
const MODE_MARBLE = 1

var _edit_avatar = null
var _marble_avatar = null
var _mode = MODE_EDIT


func _ready():
	_edit_avatar = EditAvatarScene.instance()
	_marble_avatar = MarbleAvatarScene.instance()
	set_mode(MODE_EDIT)


func _exit_tree():
	if not _edit_avatar.is_inside_tree():
		_edit_avatar.free()
	if not _marble_avatar.is_inside_tree():
		_marble_avatar.free()


func _input(event):
	if event is InputEventKey:
		if event.pressed:
			match event.scancode:
				KEY_TAB:
					if _mode == MODE_EDIT:
						set_mode(MODE_MARBLE)
					else:
						set_mode(MODE_EDIT)
				KEY_ESCAPE:
					if _mode == MODE_MARBLE:
						set_mode(MODE_EDIT)
				KEY_K:
					save_machine()
				KEY_L:
					load_machine()


func set_mode(mode):
	_mode = mode
	
	if _mode == MODE_MARBLE:
		var marbles = get_tree().get_nodes_in_group("marbles")
		if len(marbles) == 0:
			print("Cannot switch to marble mode, there are no marbles")
			return
		print("Switch to marble mode")
		if _edit_avatar.is_inside_tree():
			remove_from_tree(_edit_avatar)
		if not _marble_avatar.is_inside_tree():
			add_child(_marble_avatar)
		_marble_avatar.set_target(marbles[0])
		
	else:
		print("Switch to edit mode")
		if _marble_avatar.is_inside_tree():
			_marble_avatar.get_parent().remove_child(_marble_avatar)
		if not _edit_avatar.is_inside_tree():
			add_child(_edit_avatar)


static func remove_from_tree(node):
	node.get_parent().remove_child(node)


func _process(delta):
	var marbles = get_tree().get_nodes_in_group("marbles")
	if len(marbles) == 0:
		if _mode == MODE_MARBLE:
			set_mode(MODE_EDIT)


func save_machine():
	var pieces = get_tree().get_nodes_in_group("pieces")
	var pieces_data = []
	for piece in pieces:
		var pos = piece.translation
		var rot = piece.rotation
		var piece_data = {
			"type": piece.filename,
			"position": [pos.x, pos.y, pos.z],
			"rotation": [rot.x, rot.y, rot.z]
		}
		pieces_data.push_back(piece_data)
	var data = {
		"pieces": pieces_data
	}
	var json = JSON.print(data, "\t", true)
	var f = File.new()
	var fpath = "save.marble"
	var err = f.open(fpath, File.WRITE)
	if err != OK:
		print("Could not save file ", fpath, ", error ", err)
		return
	f.store_string(json)
	f.close()


static func array_to_vec3(a):
	return Vector3(a[0], a[1], a[2])


func load_machine():
	var f = File.new()
	var fpath = "save.marble"
	var err = f.open(fpath, File.READ)
	if err != OK:
		print("Could not open file ", fpath, ", error ", err)
		return
	var json = f.get_as_text()
	var json_res = JSON.parse(json)
	if json_res.error != OK:
		print("Error when loading json ", fpath, ": ", json_res.error_string)
		return
	var data = json_res.result
	
	var pieces = get_tree().get_nodes_in_group("pieces")
	for piece in pieces:
		piece.queue_free()
	
	for piece_data in data.pieces:
		var piece_scene = load(piece_data.type)
		var piece = piece_scene.instance()
		var pos = array_to_vec3(piece_data.position)
		var rot = array_to_vec3(piece_data.rotation)
		piece.translation = pos
		piece.rotation = rot
		add_child(piece)
		piece.set_ghost(false)
