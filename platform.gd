extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

const BEGIN = 5;
const END = 8;
const MIDDLE = 6;
var platformWidth: int;
var towerFloor: int;
var tileMap: TileMap;
var begin;
var isFull: bool;

func _init(width, tFloor, tGround, tSet: TileMap, start, fullWidth = false):
	platformWidth = width;

	towerFloor = tGround - tFloor;
	tileMap = tSet;
	begin = start;
	isFull = fullWidth;
	pass

func draw():
	var beginTile = BEGIN;
	var endTile = END;
	if isFull:
		beginTile = MIDDLE;
		endTile = MIDDLE;

	tileMap.set_cell(begin, towerFloor, beginTile);
	for i in range(1, platformWidth - 1):

		tileMap.set_cell(begin + i, towerFloor, MIDDLE);
		pass

	tileMap.set_cell(begin + platformWidth - 1, towerFloor, endTile);
	pass
