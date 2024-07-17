extends Area3D

var address : String
var type : String
var view_manager = null
# Called when the node enters the scene tree for the first time.
func _ready():
	view_manager = get_node("/root/Node")
	address = get_meta("address")
	type = get_meta("type")


# Called every frame. 'delta' is the elapsed time since the previous frame.
# func _process(delta):


func _on_location_clicked(_camera, _event, _pos, _n, _shape_idx):
	if _event is InputEventMouseButton and _event.pressed:
		print("Location Clicked : " + address)
		view_manager.load_world(address, type)
