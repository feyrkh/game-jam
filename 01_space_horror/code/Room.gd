extends Node2D
class_name Room

export(NodePath) var LeftExitTeleporterPath
export(NodePath) var RightExitTeleporterPath
export(NodePath) var UpExitTeleporterPath
export(NodePath) var DownExitTeleporterPath
export(NodePath) var LeftEntrancePath
export(NodePath) var RightEntrancePath
export(NodePath) var UpEntrancePath
export(NodePath) var DownEntrancePath

var LeftExitTeleporter:Teleporter
var RightExitTeleporter:Teleporter
var UpExitTeleporter:Teleporter
var DownExitTeleporter:Teleporter
var LeftEntrance:Position2D
var RightEntrance:Position2D
var UpEntrance:Position2D
var DownEntrance:Position2D

var LeftExitBlocker:Node2D
var RightExitBlocker:Node2D
var UpExitBlocker:Node2D
var DownExitBlocker:Node2D

func _ready():
	if LeftExitTeleporterPath: LeftExitTeleporter = get_node(LeftExitTeleporterPath)
	if RightExitTeleporterPath: RightExitTeleporter = get_node(RightExitTeleporterPath)
	if UpExitTeleporterPath: UpExitTeleporter = get_node(UpExitTeleporterPath)
	if DownExitTeleporterPath: DownExitTeleporter = get_node(DownExitTeleporterPath)
	if LeftEntrancePath: LeftEntrance = get_node(LeftEntrancePath)
	if RightEntrancePath: RightEntrance = get_node(RightEntrancePath)
	if UpEntrancePath: UpEntrance = get_node(UpEntrancePath)
	if DownEntrancePath: DownEntrance = get_node(DownEntrancePath)
	LeftExitBlocker = find_node("LeftExitBlocker", true, true)
	RightExitBlocker = find_node("RightExitBlocker", true, true)
	UpExitBlocker = find_node("UpExitBlocker", true, true)
	DownExitBlocker = find_node("DownExitBlocker", true, true)
