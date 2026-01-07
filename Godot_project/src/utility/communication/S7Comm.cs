using Godot;
using System;
using Sharp7;
using System.Net.WebSockets;
using System.Runtime.CompilerServices;
using System.Runtime.InteropServices.Marshalling;
using System.Security.Claims;
using System.Text;
using System.Threading.Tasks.Dataflow;
using System.Security.AccessControl;
using Godot.Collections;
using System.ComponentModel.DataAnnotations;

public partial class S7Comm : Node
{
	public enum DATA_TYPE
	{
		BOOL = 0,
		INT = 1,
		WORD = 2,
		REAL = 3,
		STRING = 4
	};

	public enum MEM_AREA
	{
		INPUT_DONT_USE = 0x81, // NOT WORK, PLC's IMAGE PROCESS TABLE CLEARS EVERY LOOP START
		OUTPUT = 0x82,
		M_MEM = 0x83,
		DATA_BLOCK = 0x84,
		COUNTER = 0x1C,
		TIMER = 0x1D
	};

	public Dictionary<DATA_TYPE, int> DATA_SIZE = new Dictionary<DATA_TYPE, int>()
	{
		{ DATA_TYPE.BOOL,1 },
		{ DATA_TYPE.INT, 2 },
		{ DATA_TYPE.WORD,2 },
		{ DATA_TYPE.REAL,4 },
		{ DATA_TYPE.STRING,254 } // max len
	};
// dictionary DATA_TYPE:size_value
// var dataSize := DATA_SIZE.new ()

	Sharp7.S7Client client;
	byte[] buffer = new byte[64];

	public override void _Ready()
	{
		base._Ready();
	}

	public void CreateClient()
	{
		client = new Sharp7.S7Client();
	}

	public int ConnectToPLC(String ip, int rack, int slot)
	{
		int result = client.ConnectTo(ip,rack,slot);
		if(result != 0)
		{
			client.Disconnect();
		}
		return result;
	}

	public bool IsConnected()
	{
		return client.Connected;
	}

	public Variant TestFunc()
	{
		GD.Print("HElloo");
		return 420;
	}

	public Variant DBRead(DATA_TYPE dataType, int DBNumber, int offset, int bit)
	{
		return ReadTag(MEM_AREA.DATA_BLOCK, dataType, DBNumber, offset, bit);
	}

	public void DBWrite(DATA_TYPE dataType, int DBNumber, int offset, int bit, Variant value)
	{
		WriteTag(MEM_AREA.DATA_BLOCK, dataType, DBNumber, offset, bit, value);
	}

	public Variant MBRead(DATA_TYPE dataType, int offset, int bit)
	{
		return ReadTag(MEM_AREA.M_MEM, dataType, 0, offset, bit);
	}

	public void MBWrite(DATA_TYPE dataType, int offset, int bit, Variant value)
	{
		WriteTag(MEM_AREA.M_MEM, dataType, 0, offset, bit, value);
	}

	public Variant InputRead(DATA_TYPE dataType, int offset, int bit)
	{
		return ReadTag(MEM_AREA.INPUT_DONT_USE, dataType, 0, offset, bit);
	}

	public void InputWrite(DATA_TYPE dataType, int offset, int bit, Variant value)
	{
		WriteTag(MEM_AREA.INPUT_DONT_USE, dataType, 0, offset, bit, value);
	}

	public Variant OutputRead(DATA_TYPE dataType, int offset, int bit)
	{
		return ReadTag(MEM_AREA.OUTPUT, dataType, 0, offset, bit);
	}

	public void OutputWrite(DATA_TYPE dataType, int offset, int bit, Variant value)
	{
		WriteTag(MEM_AREA.OUTPUT, dataType, 0, offset, bit, value);
	}

	public Variant ReadTag(MEM_AREA memArea, DATA_TYPE dataType, int db, int offset, int bit = 0)
	{
		//int dataSize = PLCDataTypes.dataSizes[dataType];
		int dataSize = DATA_SIZE[dataType];

		int value = client.ReadArea((int)memArea, db, offset, dataSize, S7Consts.S7WLByte, buffer);
		switch (dataType)
		{
			// Convert.ToXXX looks like not working
			case DATA_TYPE.WORD:
			case DATA_TYPE.INT:
				return (int)Sharp7.S7.GetIntAt(buffer, 0);
			case DATA_TYPE.BOOL:
				//return Convert.ToBoolean(Sharp7.S7.GetBitAt(buffer, 0, bit));
				return (bool)Sharp7.S7.GetBitAt(buffer, 0, bit);
			case DATA_TYPE.REAL:
				return (float)Sharp7.S7.GetRealAt(buffer, 0);
			default:
				GD.Print("Read Tag: NYI data_type:", dataType);
				return -1;
		}
	}

	public void WriteTag(MEM_AREA memArea, DATA_TYPE dataType, int db, int offset, int bit, Variant value)
	{
		//int dataSize = PLCDataTypes.dataSizes[dataType];
		int dataSize = DATA_SIZE[dataType];
		switch (dataType)
		{
			case DATA_TYPE.WORD:
			case DATA_TYPE.INT:
				//short intVal = value;
				S7.SetIntAt(buffer, 0, (short)value);
				client.WriteArea((int)memArea, db, offset, dataSize, S7Consts.S7WLByte, buffer);
				break;
			case DATA_TYPE.BOOL:
				//GD.Print(memArea," | ", dataType, " | ", db, " | ", offset, " | ", bit, " | ", value);
				int status = client.ReadArea((int)memArea, db, offset, 1, S7Consts.S7WLByte, buffer);
				bool boolVal = (bool)value;
				S7.SetBitAt(ref buffer, 0, bit, boolVal);
				status = client.WriteArea((int)memArea, db, offset, dataSize, S7Consts.S7WLByte, buffer);
				break;
			case DATA_TYPE.REAL:
				float floatVal = Convert.ToSingle(value);
				S7.SetRealAt(buffer, 0, floatVal);
				client.WriteArea((int)memArea, db, offset, dataSize, S7Consts.S7WLByte, buffer);
			break;
			default:
				GD.Print("Write Tag: NYI data_type:", dataType);
				break;
		}
	}
	public int ReadInt(int dbNum, int offset)
	{
		int result = client.DBRead(dbNum, offset, 2, buffer);
		if (result != 0)
		{
			GD.Print("failed to read: ", result);
		}
		return Sharp7.S7.GetIntAt(buffer, 0);
	}

	public void WriteInt(int dbNum, int offset, int value)
	{
		S7.SetIntAt(buffer, 0, (short)value);
		int result = client.DBWrite(dbNum, offset, 2, buffer);
		if (result != 0)
		{
			GD.Print("failed to write: ", result);
		}
	}

	public bool ReadBool(int dbNum, int offset, int bit)
	{
		int result = client.DBRead(dbNum, offset, 1, buffer);
		if (result != 0)
		{
			GD.Print("failed to read: ", result);
		}
		return Sharp7.S7.GetBitAt(buffer, 0, bit);
	}

	public void WriteBool(int dbNum, int offset, int bit, bool value)
	{       // read first byte
		int result = client.DBRead(dbNum, offset, 1, buffer);
		if (result != 0)
		{
			GD.Print("failed to read: ", result);
		}
		// set bit
		S7.SetBitAt(ref buffer, 0, bit, value);
		// write byte back
		result = client.DBWrite(dbNum, offset, 1, buffer);
		if (result != 0)
		{
			GD.Print("failed to read: ", result);
		}
	}
}

/*
// TODO: error check (oisko joku set flag?)
// comment
	public const byte S7AreaPE = 0x81; # IN
	public const byte S7AreaPA = 0x82; # OUT
	public const byte S7AreaMK = 0x83; # M
	public const byte S7AreaDB = 0x84; # DB
	public const byte S7AreaCT = 0x1C; # counter
	public const byte S7AreaTM = 0x1D; # timer
// comment end
public object ReadTag(int memArea, PLCDataTypes.DATA_TYPE dataType, int db, int offset, int bytesToRead, int bit = 0)
{
	int value = client.ReadArea(memArea, db, offset, bytesToRead, S7Consts.S7WLByte, buffer);
	switch (dataType)
	{
		case PLCDataTypes.DATA_TYPE.WORD:
		case PLCDataTypes.DATA_TYPE.INT:
			return Convert.ToInt32(Sharp7.S7.GetIntAt(buffer, 0));
		case PLCDataTypes.DATA_TYPE.BOOL:
			return Sharp7.S7.GetBitAt(buffer, 0, bit);
		case PLCDataTypes.DATA_TYPE.REAL:
			return Sharp7.S7.GetRealAt(buffer, 0);
		default:
			GD.Print("Read Tag: wtf retuned -1");
			return -1;
	}
}
public void WriteTag(int memArea, PLCDataTypes.DATA_TYPE dataType, int db, int offset, int bit, object value)
{
	switch (dataType)
	{
		case PLCDataTypes.DATA_TYPE.WORD:
		case PLCDataTypes.DATA_TYPE.INT:
			short intVal = Convert.ToInt16(value);
			S7.SetIntAt(buffer, 0, intVal);
			client.WriteArea(memArea, db, offset, 2, S7Consts.S7WLByte, buffer);
			break;
		case PLCDataTypes.DATA_TYPE.BOOL:
			//int status = ReadTag(memArea, PLCDataTypes.DATA_TYPE.INT, db, offset, 1, bit);
			int status = client.ReadArea(memArea, db, offset, 1, S7Consts.S7WLByte, buffer);
			bool boolVal = Convert.ToBoolean(value);
			S7.SetBitAt(ref buffer, 0, bit, boolVal);
			client.WriteArea(memArea, db, offset, 1, S7Consts.S7WLByte, buffer);
			break;
		case PLCDataTypes.DATA_TYPE.REAL:
			float floatVal = Convert.ToSingle(value);
			S7.SetRealAt(buffer, 0, floatVal);
			client.WriteArea(memArea, db, offset, 4, S7Consts.S7WLByte, buffer)

			break;
		default:
			break;
	}
}

public int ReadInt(int dbNum, int offset)
{
	int result = client.DBRead(dbNum, offset, 2, buffer);
	if (result != 0)
	{
		GD.Print("failed to read: ", result);
	}
	return Sharp7.S7.GetIntAt(buffer, 0);
}

public void WriteInt(int dbNum, int offset, int value)
{
	S7.SetIntAt(buffer, 0, (short)value);
	int result = client.DBWrite(dbNum, offset, 2, buffer);
	if (result != 0)
	{
		GD.Print("failed to write: ", result);
	}
}

public bool ReadBool(int dbNum, int offset, int bit)
{
	int result = client.DBRead(dbNum, offset, 1, buffer);
	if (result != 0)
	{
		GD.Print("failed to read: ", result);
	}
	return Sharp7.S7.GetBitAt(buffer, 0, bit);
}

public void WriteBool(int dbNum, int offset, int bit, bool value)
{       // read first byte
	int result = client.DBRead(dbNum, offset, 1, buffer);
	if (result != 0)
	{
		GD.Print("failed to read: ", result);
	}
	// set bit
	S7.SetBitAt(ref buffer, 0, bit, value);
	// write byte back
	result = client.DBWrite(dbNum, offset, 1, buffer);
	if (result != 0)
	{
		GD.Print("failed to read: ", result);
	}
}

*/
