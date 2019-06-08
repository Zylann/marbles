extends Control

signal save_path_selected(fpath)
signal load_path_selected(fpath)

var _file_dialog = null


func _ready():
	var fd = FileDialog.new()
	fd.access = FileDialog.ACCESS_FILESYSTEM
	fd.add_filter("*.marble ; Marble files")
	#fd.current_dir = OS.get_executable_path()
	fd.hide()
	fd.connect("file_selected", self, "_on_FileDialog_file_selected")
	add_child(fd)
	_file_dialog = fd


func close():
	hide()
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)


func _on_ResumeButton_pressed():
	close()


func _on_QuitButton_pressed():
	get_tree().quit()


func _on_SaveButton_pressed():
	_file_dialog.mode = FileDialog.MODE_SAVE_FILE
	_file_dialog.popup_centered_ratio()


func _on_LoadButton_pressed():
	_file_dialog.mode = FileDialog.MODE_OPEN_FILE
	_file_dialog.popup_centered_ratio()


func _on_FileDialog_file_selected(fpath):
	if _file_dialog.mode == FileDialog.MODE_OPEN_FILE:
		emit_signal("load_path_selected", fpath)
	else:
		emit_signal("save_path_selected", fpath)
	close()


#func _notification(what):
#	match what:
#		NOTIFICATION_VISIBILITY_CHANGED:
#			if visible:
#				Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
