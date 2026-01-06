extends Node
class_name PLCData


@export var enabled:bool = true
#@export_enum("BOOL","INT") var dataType:int
#@export var memArea:MEM_AREA
#@export var memArea:PlcDataTypes.MEM_AREAS
#@export var dataType:PlcDataTypes.DATA_TYPE
@export var dataType:DATA_TYPE
@export var value:Variant
@export_category("Tag data")
@export var DB_num:int
@export var offset:int
@export var bit:int
var size:int

enum DATA_TYPE { BOOL, INT, WORD, STRING }
#enum MEM_AREA {DATA_BLOCK, INPUT, OUTPUT, M_MEMORY}

func _ready() -> void:
	if dataType == null:
		assert(false, "DATA TYPE NOT SET: " + owner.name)
	match dataType:
		DATA_TYPE.BOOL:
			size = 1
			value = false
		DATA_TYPE.INT:
			size = 2
			value = 0
	add_to_group("PLC_TAGS")

func UpdateTagValue(newVal:Variant)->void:
	value = newVal

func ReadNewData()->void:
	match dataType:
		DATA_TYPE.BOOL:
			value = S7Wrapper.ReadBool(DB_num, offset, bit)
		DATA_TYPE.INT:
			value = S7Wrapper.ReadInt(DB_num, offset)
