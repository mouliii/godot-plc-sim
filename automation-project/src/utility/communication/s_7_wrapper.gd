extends Node

# https://snap7.sourceforge.net/sharp7.html
# Pipeline:
# Sharp7 -> S7Comm.cs -> (PLCDataTypes) -> S7Wrapper.gd

@onready var plc_data_types: PLCDataTypes = $PLCDataTypes

var sharp7:Node

func _ready():
	var sharp7cs = load("uid://cd2abx2w82ec3")
	sharp7 = sharp7cs.new()
	sharp7.CreateClient()

	#var intval = sharp7.DBRead($PLCDataTypes.memoryAreas, 1, 0, 0)
	

func ConnectToPLC(ip:String,rack:int,slot:int) -> int:
	var status = sharp7.ConnectToPLC(ip,rack,slot)
	return status

func IsConnected()->bool:
	return sharp7.IsConnected()

func ReadDB(dataType:PlcDataTypes.DATA_TYPES, DBNumber:int, offset:int, bit:int) -> Variant:
	return sharp7.DBRead(dataType, DBNumber, offset, bit)

func WriteDB(dataType:PlcDataTypes.DATA_TYPES, DBNumber:int, offset:int, bit:int, value:Variant):
	sharp7.DBWrite(dataType, DBNumber, offset, bit, value)

func ReadMB(dataType:PlcDataTypes.DATA_TYPES, DBNumber:int, offset:int, bit:int) -> Variant:
	return sharp7.DBRead(dataType, DBNumber, offset, bit)

func WriteMB(dataType:PlcDataTypes.DATA_TYPES, DBNumber:int, offset:int, bit:int, value:Variant):
	sharp7.DBWrite(dataType, DBNumber, offset, bit, value)

func ReadInput(dataType:PlcDataTypes.DATA_TYPES, DBNumber:int, offset:int, bit:int) -> Variant:
	return sharp7.DBRead(dataType, DBNumber, offset, bit)

func WriteInput(dataType:PlcDataTypes.DATA_TYPES, DBNumber:int, offset:int, bit:int, value:Variant):
	sharp7.DBWrite(dataType, DBNumber, offset, bit, value)

func ReadOutput(dataType:PlcDataTypes.DATA_TYPES, DBNumber:int, offset:int, bit:int) -> Variant:
	return sharp7.DBRead(dataType, DBNumber, offset, bit)

func WriteOutput(dataType:PlcDataTypes.DATA_TYPES, DBNumber:int, offset:int, bit:int, value:Variant):
	sharp7.DBWrite(dataType, DBNumber, offset, bit, value)

func ReadTag(memArea:int, dataType:PlcDataTypes.DATA_TYPE, db:int, offset:int, bit:int) -> Variant:
	return sharp7.ReadTag(memArea, dataType, db, offset, bit)

func WriteTag(memArea:int, dataType:PlcDataTypes.DATA_TYPE, db:int, offset:int, bit:int, value:Variant) -> Variant:
	return sharp7.WriteTag(memArea, dataType, db, offset, bit, value)
# OLD

func WriteInt(db:int, offset:int, size:int, value:int)->void:
	sharp7.WriteInt(db,offset,size,value)

func ReadInt(db:int, offset:int) -> int:
	var i = sharp7.ReadInt(db, offset)
	return i

func WriteBool(db:int, offset:int, bit:int, value:bool)->void:
	sharp7.WriteBool(db,offset,bit,value)

func ReadBool(db:int, offset:int, bit:int) -> bool:
	var i = sharp7.ReadBool(db,offset,bit)
	return i;
