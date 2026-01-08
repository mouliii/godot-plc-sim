extends Node
class_name PLCTag

@export var enabled:bool = true
@export var dataType:S7Wrapper.DATA_TYPE = S7Wrapper.DATA_TYPE.BOOL
@export var memoryArea:S7Wrapper.MEM_AREA = S7Wrapper.MEM_AREA.DATA_BLOCK
## Only set this value if debugging, otherwise use Write(), reading is 'ok', but prefer Read()
@export var value:Variant
@export_category("Tag data")
@export var DB_num:int
@export var offset:int
@export var bit:int
var size:int

func _ready() -> void:
	match dataType:
		S7Wrapper.DATA_TYPE.BOOL:
			size = 1
			value = false
		S7Wrapper.DATA_TYPE.INT:
			size = 2
			value = 0
	add_to_group("PLC_TAGS")

# CALLED IN MAIN AUTOMATICALLY
func ReadNewData()->void:
	value = Fetch()

func Write(newVal:Variant)->void:
	S7Wrapper.WriteTag(memoryArea, dataType, DB_num, offset, bit, newVal)
func Fetch()->Variant:
	return S7Wrapper.ReadTag(memoryArea, dataType, DB_num, offset, bit)
func Read()->Variant:
	return value
