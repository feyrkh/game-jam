extends Node2D
const BASIC_ROOM_TYPE_COUNT = 2
const GRID_SEPARATION_PIXELS = 1000
const MAX_RETRIES_PER_ROOM = 500

var startRoom:RoomSlot
var totalRooms:int = 0

signal mapGenerationComplete

class Direction:
	var dx:int
	var dy:int
	
	func _init(_dx, _dy):
		self.dx = _dx
		self.dy = _dy

var LEFT = Direction.new(-1, 0)
var RIGHT = Direction.new(1, 0)
var UP = Direction.new(0, -1)
var DOWN = Direction.new(0, 1)

const NO_UP_EXIT = ['starbeast']
const NO_DOWN_EXIT = ['starbeast']
const NO_LEFT_EXIT = []
const NO_RIGHT_EXIT = []

class RoomSlot:
	var x:int
	var y:int
	var roomName:String
	var upExitOpen:bool
	var downExitOpen:bool
	var leftExitOpen:bool
	var rightExitOpen:bool
	var roomInstance:Room

	func _init(_x, _y, _roomName):
		self.roomName = _roomName
		self.x = _x
		self.y = _y
		
	func receiveConnection(otherRoom, direction):
		if direction.dx == -1 && NO_RIGHT_EXIT.find(roomName) < 0:
			rightExitOpen = true
			otherRoom.leftExitOpen = true
		if direction.dx == 1 && NO_LEFT_EXIT.find(roomName) < 0:
			leftExitOpen = true
			otherRoom.rightExitOpen = true
		if direction.dy == -1 && NO_DOWN_EXIT.find(roomName) < 0:
			downExitOpen = true
			otherRoom.upExitOpen = true
		if direction.dy == 1 && NO_UP_EXIT.find(roomName) < 0:
			upExitOpen = true
			otherRoom.downExitOpen = true

var directions = [LEFT, RIGHT, UP, DOWN]
export var mapSize = 6
export var numExtraRooms = 5
export var maxShieldConsoleCount = 3
var map:Array # of arrays of RoomSlots
var rooms:Array

func _ready():
	generateMap()
	instantiateMap(self)

func randChoice(arr):
	if arr && arr.size() > 0:
		return arr[randi() % arr.size()]

func buildNewRoom(nextX, nextY, roomType, direction, curRoom):
	totalRooms += 1
	var newRoom = RoomSlot.new(nextX, nextY, roomType)
	rooms.append(newRoom)
	map[nextY][nextX] = newRoom
	if curRoom:
		newRoom.receiveConnection(curRoom, direction)
	return newRoom

func generateMap():
	randomize()
	var retriesAllowed = MAX_RETRIES_PER_ROOM
	totalRooms = 0
	map = []
	map.resize(mapSize)
	for i in range(mapSize):
		map[i] = []
		map[i].resize(mapSize)
	
	var remainingRooms = ['starbeast']
	for i in range(numExtraRooms):
		remainingRooms.append('basicRoom'+str(randi()%BASIC_ROOM_TYPE_COUNT))
	remainingRooms.shuffle()
	rooms = []
	
	var curRoom:RoomSlot = buildNewRoom(mapSize/2, mapSize/2, remainingRooms.pop_back(), null, null)
	startRoom = curRoom
	while remainingRooms.size() > 0 && totalRooms < mapSize*mapSize:
		if retriesAllowed <= 0:
			push_error("Map generation retried too many times, couldn't find a valid map!")
			generateMap()
		curRoom = randChoice(rooms)
		var nextDirection:Direction = randChoice(directions)
		if nextDirection == LEFT && NO_LEFT_EXIT.find(curRoom) >= 0:
			# Trying to move left, but this room has no left exit
			retriesAllowed -= 1;
			continue
		if nextDirection == RIGHT && NO_RIGHT_EXIT.find(curRoom) >= 0:
			# Trying to move right, but this room has no right exit
			retriesAllowed -= 1;
			continue
		if nextDirection == UP && NO_UP_EXIT.find(curRoom) >= 0:
			# Trying to move up, but this room has no up exit
			retriesAllowed -= 1;
			continue
		if nextDirection == DOWN && NO_DOWN_EXIT.find(curRoom) >= 0:
			# Trying to move down, but this room has no down exit
			retriesAllowed -= 1;
			continue
		var nextX:int = curRoom.x + nextDirection.dx
		var nextY:int = curRoom.y + nextDirection.dy
		if nextX < 0 || nextY < 0 || nextX >= mapSize || nextY >= mapSize:
			continue
		if map[nextY][nextX]:
			map[nextY][nextX].receiveConnection(curRoom, nextDirection)
		else:
			var nextRoom = remainingRooms[-1]
			if nextDirection == LEFT && NO_LEFT_EXIT.find(nextRoom) >= 0:
				# Trying to move left, but this room has no left exit
				retriesAllowed -= 1;
				continue
			if nextDirection == RIGHT && NO_RIGHT_EXIT.find(nextRoom) >= 0:
				# Trying to move right, but this room has no right exit
				retriesAllowed -= 1;
				continue
			if nextDirection == UP && NO_UP_EXIT.find(nextRoom) >= 0:
				# Trying to move up, but this room has no up exit
				retriesAllowed -= 1;
				continue
			if nextDirection == DOWN && NO_DOWN_EXIT.find(nextRoom) >= 0:
				# Trying to move down, but this room has no down exit
				retriesAllowed -= 1;
				continue
			buildNewRoom(nextX, nextY, remainingRooms.pop_back(), nextDirection, curRoom)
			retriesAllowed = MAX_RETRIES_PER_ROOM

func instantiateMap(container:Node2D):
	var roomInstance:Room
	var roomData:RoomSlot
	# Create rooms and position them on the map
	for y in range(mapSize):
		for x in range(mapSize):
			if map[y][x]:
				roomData = map[y][x]
				var scene = load('res://levels/main/rooms/'+roomData.roomName+'.tscn')
				roomInstance = scene.instance()
				container.add_child(roomInstance)
				roomInstance.position = Vector2(x*GRID_SEPARATION_PIXELS, y*GRID_SEPARATION_PIXELS)
				roomData.roomInstance = roomInstance
	yield(get_tree().create_timer(0.5), "timeout")
	
	for y in range(mapSize):
		for x in range(mapSize):
			if map[y][x]:
				roomData = map[y][x]
				var curRoom:Room = roomData.roomInstance
				if x > 0:
					var otherRoomData:RoomSlot = map[y][x-1]
					if otherRoomData:
						var otherRoom:Room = otherRoomData.roomInstance
						if curRoom.LeftExitTeleporter && otherRoom.RightEntrance && otherRoom.RightExitTeleporter && curRoom.LeftEntrance:
							curRoom.LeftExitTeleporter.setExit(otherRoom.RightEntrance)
							curRoom.LeftExitBlocker.queue_free()
							otherRoom.RightExitTeleporter.setExit(curRoom.LeftEntrance)
							otherRoom.RightExitBlocker.queue_free()
				if y > 0:
					var otherRoomData:RoomSlot = map[y-1][x]
					if otherRoomData:
						var otherRoom:Room = otherRoomData.roomInstance
						if curRoom.UpExitTeleporter && otherRoom.DownEntrance && otherRoom.DownExitTeleporter && curRoom.UpEntrance:
							curRoom.UpExitTeleporter.setExit(otherRoom.DownEntrance)
							curRoom.UpExitBlocker.queue_free()
							otherRoom.DownExitTeleporter.setExit(curRoom.UpEntrance)
							otherRoom.DownExitBlocker.queue_free()
	
	evenlyDistributeItems(container, @"shieldConsoles", maxShieldConsoleCount)
	
	emit_signal("mapGenerationComplete", startRoom.roomInstance)

func evenlyDistributeItems(container:Node, containerPath:NodePath, maxItemCount:int):
	var totalItemsKept = 0
	var itemsPerRoom = ceil(float(maxItemCount)/rooms.size())
	
	for room in rooms:
		var itemHolder = room.roomInstance.get_node(containerPath)
		if !itemHolder: continue
		var items:Array = itemHolder.get_children()
		items.shuffle()
		while items.size() > itemsPerRoom || (totalItemsKept >= maxItemCount && items.size() > 0):
			var item = items.pop_back()
			itemHolder.remove_child(item)
			item.queue_free()
		totalItemsKept += items.size()

