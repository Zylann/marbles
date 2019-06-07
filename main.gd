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
			if event.scancode == KEY_TAB:
				if _mode == MODE_EDIT:
					set_mode(MODE_MARBLE)
				else:
					set_mode(MODE_EDIT)
			elif event.scancode == KEY_ESCAPE:
				set_mode(MODE_EDIT)


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

