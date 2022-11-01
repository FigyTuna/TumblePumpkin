extends Node2D

export (NodePath)var enter
export (NodePath)var exit
export (NodePath)var extra

func get_enter():
	if enter:
		return get_node(enter)
	return null

func get_exit():
	if exit:
		return get_node(exit)
	return null

func get_extra():
	if extra:
		return get_node(extra)
	return null

func register():
	if enter:
		return enter.size
	elif extra:
		return extra.size + 3

func close():
	if enter:
		get_node(enter).close()
