extends Line2D

var queue: Array
@export var max_length: int
var player: Area2D
	
func _process(_delta):
	var pos = player.position
	
	queue.push_front(pos)
	
	if queue.size() > max_length:
		queue.pop_back()
		
	clear_points()
	
	for point in queue:
		add_point(point)
