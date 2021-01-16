extends Node

const Platform = preload("res://platform.gd");
	
var towerWidth = [];

const TOWER_GROUND = 57;
const TOWER_WIDTH = 28;
const PlATFORM_STEP = 3;

func buildWalls(towerHeight, TileMap: TileMap):
	TileMap.set_cell(0, TOWER_GROUND, 4);
	TileMap.set_cell(TOWER_WIDTH, TOWER_GROUND, 4);
	for i in range(1, towerHeight):
		TileMap.set_cell(0, TOWER_GROUND - i, 3);
		TileMap.set_cell(TOWER_WIDTH, TOWER_GROUND - i, 3);
		pass
	TileMap.set_cell(0, TOWER_GROUND - towerHeight, 2);
	TileMap.set_cell(TOWER_WIDTH, TOWER_GROUND - towerHeight, 2);
	pass

func buildPlatform(TileMap, towerWidth, towerFloor, rng, platformWidth):
	var index = floor(rng.randf_range(0, towerWidth.size() - platformWidth));

	var begin = towerWidth[index];
	var platform = Platform.new(platformWidth, towerFloor, TOWER_GROUND, TileMap, begin);

	platform.draw();
	pass

func buildFullFloor(TileMap, towerFloor):
	var platform = Platform.new(TOWER_WIDTH - 1, towerFloor, TOWER_GROUND, TileMap, 1, true);
	platform.draw();
	pass;

func buildTower(TileMap, towerHeight, winZone):
	buildWalls(towerHeight, TileMap);
	var rng = RandomNumberGenerator.new();
	rng.randomize();

	for i in range(1, TOWER_WIDTH):
		towerWidth += [i];
	pass

	for i in range(1, towerHeight):
		if  i + 1 == towerHeight:
			buildFullFloor(TileMap, i);
			winZone.position.y = (TOWER_GROUND - towerHeight) * 35;

		if i % PlATFORM_STEP == 0:
			if i % (PlATFORM_STEP * 10) == 0:
				buildFullFloor(TileMap, i);
				winZone.position.y = (TOWER_GROUND - towerHeight) * 35;
			else:
				var platformWidth = floor(rng.randf_range(6, 15));
				buildPlatform(TileMap, towerWidth, i, rng, platformWidth);
			pass
		pass
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
