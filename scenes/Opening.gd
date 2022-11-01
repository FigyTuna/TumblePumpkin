tool
extends Area2D

export(int, "Small", "Medium", "Large") var size setget set_size
export(int, "Enter", "Exit", "Extra") var kind setget set_kind

var activated = false

func _ready():
	$Walls.enabled(false)
	if not Engine.editor_hint:
		$Polygon2D.visible = false

func activate():
	if not activated and kind == 0:
		activated = true
		return true
	return false

func close():
	$Walls.enabled(true)

func set_size(s):
	size = s
	var px
	if size == 0:
		px = 100
	elif size == 1:
		px = 200
	else:
		px = 400
	var polygon = PoolVector2Array()
	polygon.append(Vector2(px, -10))
	polygon.append(Vector2(px, 10))
	polygon.append(Vector2(-px, 10))
	polygon.append(Vector2(-px, -10))
	$Polygon2D.polygon = polygon
	$CollisionPolygon2D.polygon = polygon

func set_kind(k):
	kind = k
	if kind == 0:
		$Polygon2D.color = Color(1, 0, 0)
	elif kind == 1:
		$Polygon2D.color = Color(0, 0, 1)
	else:
		$Polygon2D.color = Color(0, 1, 0)
