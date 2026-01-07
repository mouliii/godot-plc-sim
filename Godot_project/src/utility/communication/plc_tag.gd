extends Node
class_name PLCTag

@export var tagData:TagData

func _ready() -> void:
	match tagData.dataType:
		S7Wrapper.DATA_TYPE.BOOL:
			tagData.size = 1
			tagData.value = false
		S7Wrapper.DATA_TYPE.INT:
			tagData.size = 2
			tagData.value = 0
	add_to_group("PLC_TAGS")

# CALLED IN MAIN AUTOMATICALLY
func ReadNewData()->void:
	tagData.value = Fetch()

func Write(newVal:Variant)->void:
	S7Wrapper.WriteTag(tagData.memoryArea, tagData.dataType, tagData.DB_num, tagData.offset, tagData.bit, newVal)
func Fetch()->Variant:
	return S7Wrapper.ReadTag(tagData.memoryArea, tagData.dataType, tagData.DB_num, tagData.offset, tagData.bit)
func Read()->Variant:
	return tagData.value
