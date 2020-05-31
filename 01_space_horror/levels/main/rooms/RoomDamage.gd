extends TileMap

export(Vector2) var contentsTopLeft = Vector2(2, 2)
export(Vector2) var contentsBottomRight = Vector2(13, 8)
export(String) var holeTileName = "tilehole.png 8"

var contentsRange:Vector2
var player

func _ready():
	randomize()
	contentsRange = contentsBottomRight-contentsTopLeft
	player = get_tree().get_nodes_in_group("player")[0]
	

func damage():
	var holeTile = self.tile_set.find_tile_by_name(holeTileName)
	print_debug("holeTile = ", holeTile)
	for i in range(10):
		var holeTileX = randi()%int(contentsRange.x) + int(contentsTopLeft.x)
		var holeTileY = randi()%int(contentsRange.y) + int(contentsTopLeft.y)
		if !isTileNearPlayer(holeTileX, holeTileY):
			print_debug("Placing a hole: ", holeTileX, ",", holeTileY)
			self.set_cell(holeTileX, holeTileY, holeTile)
		else:
			print_debug("Skipping a hole: ", holeTileX, ",", holeTileY)

func isTileNearPlayer(x,y):
	var tileGlobalX = global_position.x + cell_size.x/2 + x*cell_size.x
	var tileGlobalY = global_position.y + cell_size.y/2 + y*cell_size.y
	var xDist = abs(player.global_position.x - tileGlobalX)/cell_size.x
	var yDist = abs(player.global_position.y - tileGlobalY)/cell_size.y
	if xDist <= 3 and yDist <= 3:
		return true
	
