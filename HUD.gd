extends CanvasLayer

var gamePoints = 0;

func setPoints():
	$Points.text = "%06d" % gamePoints;

func _ready():
	setPoints();

func _on_climber_points_added(points):
	gamePoints += points;
	setPoints();
	pass # Replace with function body.
