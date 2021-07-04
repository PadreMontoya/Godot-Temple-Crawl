extends KinematicBody2D

onready var nav : Navigation2D = get_parent().get_node("Navigation2D")
onready var player : KinematicBody2D = get_parent().get_node("Player")

var path : PoolVector2Array = []
var speed := 50

const eps = 1.5

func _ready() -> void:
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	pass
	
func _draw():
	# if there are path to draw
	if path.size() > 1:
		for p in path:
			draw_circle(p - global_position, 8, Color(1, 0, 0)) # we draw a circle (convert to global global_position first)

func _process(delta):
	# Calculate the movement distance for this frame
	path = nav.get_simple_path(global_position, player.global_position, false)
	
	if path.size() > 1:
		#print("Path from " + String(global_position) + " to " + String(player.global_position) + ": " + String(path))
		var distance = path[0] - global_position
		var direction = distance.normalized() # direction of movement
		if distance.length() > eps or path.size() > 2:
			global_position = global_position + (direction * speed * delta)

		update() # we update the node so it has to draw it self again
