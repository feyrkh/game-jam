extends Node2D

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
		if direction.dx == -1:
			rightExitOpen = true
			otherRoom.leftExitOpen = true
		if direction.dx == 1:
			leftExitOpen = true
			otherRoom.rightExitOpen = true
		if direction.dy == -1:
			downExitOpen = true
			otherRoom.upExitOpen = true
		if direction.dy == 1:
			upExitOpen = true
			otherRoom.downExitOpen = true

var directions = [LEFT, RIGHT, UP, DOWN]
export var mapSize = 6
var map:Array # of arrays of RoomSlots
var rooms:Array
export var numExtraRooms = 5

func _ready():
	generateMap()
	instantiateMap(self)

func randChoice(arr):
	if arr && arr.size() > 0:
		return arr[randi() % arr.size()]

func buildNewRoom(nextX, nextY, roomType, nextDirection, curRoom):
	totalRooms += 1
	var newRoom = RoomSlot.new(nextX, nextY, roomType)
	rooms.append(newRoom)
	map[nextY][nextX] = newRoom
	if curRoom:
		newRoom.receiveConnection(curRoom, nextDirection)	
	return newRoom

func generateMap():
	totalRooms = 0
	map = []
	map.resize(mapSize)
	for i in range(mapSize):
		map[i] = []
		map[i].resize(mapSize)
	
	var remainingRooms = []
	for i in range(numExtraRooms):
		remainingRooms.append('basicRoom')
	remainingRooms.shuffle()
	rooms = []
	
	var curRoom:RoomSlot = buildNewRoom(mapSize/2, mapSize/2, remainingRooms.pop_back(), null, null)
	startRoom = curRoom
	while remainingRooms.size() > 0 && totalRooms < mapSize*mapSize:
		curRoom = randChoice(rooms)
		var nextDirection:Direction = randChoice(directions)
		var nextX:int = curRoom.x + nextDirection.dx
		var nextY:int = curRoom.y + nextDirection.dy
		if nextX < 0 || nextY < 0 || nextX >= mapSize || nextY >= mapSize:
			continue
		if map[nextY][nextX]:
			map[nextY][nextX].receiveConnection(curRoom, nextDirection)
		else:
			buildNewRoom(nextX, nextY, remainingRooms.pop_back(), nextDirection, curRoom)

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
				roomInstance.position = Vector2(x*300, y*300)
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
						curRoom.LeftExitTeleporter.setExit(otherRoom.RightEntrance)
						curRoom.LeftExitBlocker.queue_free()
						otherRoom.RightExitTeleporter.setExit(curRoom.LeftEntrance)
						otherRoom.RightExitBlocker.queue_free()
				if y > 0:
					var otherRoomData:RoomSlot = map[y-1][x]
					if otherRoomData:
						var otherRoom:Room = otherRoomData.roomInstance
						curRoom.UpExitTeleporter.setExit(otherRoom.DownEntrance)
						curRoom.UpExitBlocker.queue_free()
						otherRoom.DownExitTeleporter.setExit(curRoom.UpEntrance)
						otherRoom.DownExitBlocker.queue_free()
						
	emit_signal("mapGenerationComplete", startRoom.roomInstance)
