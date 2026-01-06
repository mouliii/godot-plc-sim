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

public partial class S7Comm : Node
{
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

	public Variant DBRead(PLCDataTypes.DATA_TYPE dataType, int DBNumber, int offset, int bit)
	{
		return ReadTag(PLCDataTypes.memAreas[PLCDataTypes.MEM_AREAS.S7AreaDB], dataType, DBNumber, offset, bit);
	}

	public void DBWrite(PLCDataTypes.DATA_TYPE dataType, int DBNumber, int offset, int bit, Variant value)
	{
		WriteTag(PLCDataTypes.memAreas[PLCDataTypes.MEM_AREAS.S7AreaDB], dataType, DBNumber, offset, bit, value);
	}

	public Variant MBRead(PLCDataTypes.DATA_TYPE dataType, int offset, int bit)
	{
		return ReadTag(PLCDataTypes.memAreas[PLCDataTypes.MEM_AREAS.S7AreaMK], dataType, 0, offset, bit);
	}

	public void MBWrite(PLCDataTypes.DATA_TYPE dataType, int offset, int bit, Variant value)
	{
		WriteTag(PLCDataTypes.memAreas[PLCDataTypes.MEM_AREAS.S7AreaMK], dataType, 0, offset, bit, value);
	}

	public Variant InputRead(PLCDataTypes.DATA_TYPE dataType, int offset, int bit)
	{
		return ReadTag(PLCDataTypes.memAreas[PLCDataTypes.MEM_AREAS.S7AreaPE], dataType, 0, offset, bit);
	}

	public void InputWrite(PLCDataTypes.DATA_TYPE dataType, int offset, int bit, Variant value)
	{
		WriteTag(PLCDataTypes.memAreas[PLCDataTypes.MEM_AREAS.S7AreaPE], dataType, 0, offset, bit, value);
	}

	public Variant OutputRead(PLCDataTypes.DATA_TYPE dataType, int offset, int bit)
	{
		return ReadTag(PLCDataTypes.memAreas[PLCDataTypes.MEM_AREAS.S7AreaPA], dataType, 0, offset, bit);
	}

	public void OutputWrite(PLCDataTypes.DATA_TYPE dataType, int offset, int bit, Variant value)
	{
		WriteTag(PLCDataTypes.memAreas[PLCDataTypes.MEM_AREAS.S7AreaPA], dataType, 0, offset, bit, value);
	}

	public Variant ReadTag(int memArea, PLCDataTypes.DATA_TYPE dataType, int db, int offset, int bit = 0)
	{
		int dataSize = PLCDataTypes.dataSizes[dataType];
		int value = client.ReadArea(memArea, db, offset, dataSize, S7Consts.S7WLByte, buffer);
		switch (dataType)
		{
			case PLCDataTypes.DATA_TYPE.WORD:
			case PLCDataTypes.DATA_TYPE.INT:
				return Convert.ToInt32(Sharp7.S7.GetIntAt(buffer, 0));
			case PLCDataTypes.DATA_TYPE.BOOL:
				return Convert.ToBoolean(Sharp7.S7.GetBitAt(buffer, 0, bit));
			case PLCDataTypes.DATA_TYPE.REAL:
				return Convert.ToSingle(Sharp7.S7.GetRealAt(buffer, 0));
			default:
				GD.Print("Read Tag: NYI data_type:", dataType);
				return -1;
		}
	}

	public void WriteTag(int memArea, PLCDataTypes.DATA_TYPE dataType, int db, int offset, int bit, Variant value)
	{
		int dataSize = PLCDataTypes.dataSizes[dataType];
		switch (dataType)
		{
			case PLCDataTypes.DATA_TYPE.WORD:
			case PLCDataTypes.DATA_TYPE.INT:
				short intVal = Convert.ToInt16(value);
				S7.SetIntAt(buffer, 0, intVal);
				client.WriteArea(memArea, db, offset, dataSize, S7Consts.S7WLByte, buffer);
				break;
			case PLCDataTypes.DATA_TYPE.BOOL:
				//int status = ReadTag(memArea, PLCDataTypes.DATA_TYPE.INT, db, offset, 1, bit);
				int status = client.ReadArea(memArea, db, offset, 1, S7Consts.S7WLByte, buffer);
				bool boolVal = Convert.ToBoolean(value);
				S7.SetBitAt(ref buffer, 0, bit, boolVal);
				client.WriteArea(memArea, db, offset, dataSize, S7Consts.S7WLByte, buffer);
				break;
			case PLCDataTypes.DATA_TYPE.REAL:
				float floatVal = Convert.ToSingle(value);
				S7.SetRealAt(buffer, 0, floatVal);
				client.WriteArea(memArea, db, offset, dataSize, S7Consts.S7WLByte, buffer);
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
