extends Resource
class_name TagData

@export var enabled:bool = true
@export var dataType:S7Wrapper.DATA_TYPE
@export var memoryArea:S7Wrapper.MEM_AREA
@export var value:Variant
@export_category("Tag data")
@export var DB_num:int
@export var offset:int
@export var bit:int
var size:int
