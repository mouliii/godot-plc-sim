extends Node

# https://snap7.sourceforge.net/sharp7.html
var pollRate := 0.1

# **** MAKE SURE THIS MATCHES WITH S7Comm.cs ****
enum DATA_TYPE
{
	BOOL = 0,
	INT = 1,
	WORD = 2,
	REAL = 3,
	STRING = 4
};

enum MEM_AREA
{
	INPUT_DONT_USE = 0x81, # NOT WORK, PLC's IMAGE PROCESS TABLE CLEARS EVERY LOOP START
	OUTPUT = 0x82, 
	M_MEM = 0x83,
	DATA_BLOCK = 0x84, 
	COUNTER_NYI = 0x1C, 
	TIMER_NYI = 0x1D 
};

# dictionary DATA_TYPE:size_value
var dataSize:Dictionary

const ANALOG_VALUE_MAX := 27648

var sharp7:Node

func _ready():
	var dataSizeScript = DATA_SIZE.new()
	dataSize = dataSizeScript.data_size
	var sharp7cs = load("uid://cd2abx2w82ec3")
	sharp7 = sharp7cs.new()
	sharp7.CreateClient()
	$Timer.wait_time = pollRate

func ConnectToPLC(ip:String,rack:int,slot:int) -> int:
	var status = sharp7.ConnectToPLC(ip,rack,slot)
	return status

func IsConnected()->bool:
	return sharp7.IsConnected()

func ReadDB(dataType:DATA_TYPE, DBNumber:int, offset:int, bit:int) -> Variant:
	return sharp7.DBRead(dataType, DBNumber, offset, bit)

func WriteDB(dataType:DATA_TYPE, DBNumber:int, offset:int, bit:int, value:Variant):
	sharp7.DBWrite(dataType, DBNumber, offset, bit, value)

func ReadMB(dataType:DATA_TYPE, DBNumber:int, offset:int, bit:int) -> Variant:
	return sharp7.DBRead(dataType, DBNumber, offset, bit)

func WriteMB(dataType:DATA_TYPE, DBNumber:int, offset:int, bit:int, value:Variant):
	sharp7.DBWrite(dataType, DBNumber, offset, bit, value)

func ReadInput(dataType:DATA_TYPE, DBNumber:int, offset:int, bit:int) -> Variant:
	return sharp7.DBRead(dataType, DBNumber, offset, bit)

func WriteInput(dataType:DATA_TYPE, DBNumber:int, offset:int, bit:int, value:Variant):
	sharp7.InputWrite(dataType, DBNumber, offset, bit, value)

func ReadOutput(dataType:DATA_TYPE, DBNumber:int, offset:int, bit:int) -> Variant:
	return sharp7.DBRead(dataType, DBNumber, offset, bit)

func WriteOutput(dataType:DATA_TYPE, DBNumber:int, offset:int, bit:int, value:Variant):
	sharp7.DBWrite(dataType, DBNumber, offset, bit, value)

func ReadTag(memArea:MEM_AREA, dataType:DATA_TYPE, db:int, offset:int, bit:int) -> Variant:
	return sharp7.ReadTag(memArea, dataType, db, offset, bit)

func WriteTag(memArea:MEM_AREA, dataType:DATA_TYPE, db:int, offset:int, bit:int, value:Variant) -> Variant:
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

func _on_timer_timeout() -> void:
	if IsConnected():
		get_tree().call_group("PLC_TAGS", "ReadNewData")
