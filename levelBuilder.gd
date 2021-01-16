extends TileMap

var TowerBuilder = load("res://towerBuilder.gd");
onready var builder = TowerBuilder.new();
const TOWER_HEIGHT = 90;
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	builder.buildTower(self, TOWER_HEIGHT, get_node("../winZone"));
	pass # Replace with function body.
