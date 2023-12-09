extends Node

var player_delta = Vector2(0, 0)

enum LEVELS {LEVEL1, LEVEL2, LEVEL3}
var levels = {}
var current_level

enum DOORS {Door1To2, Door2To1, Door2To3, Door3To2}
var doors = {}

signal level_changed
signal player_moved
