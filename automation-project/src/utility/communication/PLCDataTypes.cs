using Godot;
using System;
using System.Collections.Generic;


[GlobalClass]
public partial class PLCDataTypes : Node
{
	//[Export] public int test_BOOLDATA = 420;
	//[Export] public MEM_AREAS memoryAreas;
	[Export] Godot.Collections.Array<DATA_TYPE> datatypes;
	[Export] Godot.Collections.Array<MEM_AREAS> memareas;


	public enum DATA_TYPE
	{
		BOOL = 0,
		INT = 1,
		WORD = 2,
		REAL = 3,
		STRING = 4
	};

	public enum MEM_AREAS
	{
		S7AreaPE = 0x81, // IN
		S7AreaPA = 0x82, // OUT
		S7AreaMK = 0x83, // M
		S7AreaDB = 0x84, // DB
		S7AreaCT = 0x1C, // counter
		S7AreaTM = 0x1D  // timer
	};

	public static readonly Dictionary<MEM_AREAS, int> memAreas = new Dictionary<MEM_AREAS, int>()
	{
		{ MEM_AREAS.S7AreaPE, 0x81 },
		{ MEM_AREAS.S7AreaPA, 0x82 },
		{ MEM_AREAS.S7AreaMK, 0x83 },
		{ MEM_AREAS.S7AreaDB, 0x84 },
		{ MEM_AREAS.S7AreaCT, 0x1C },
		{ MEM_AREAS.S7AreaTM, 0x1D }
	};

	public static readonly Dictionary<DATA_TYPE, int> dataSizes = new Dictionary<DATA_TYPE, int>()
	{
		{ DATA_TYPE.BOOL, 1 },
		{ DATA_TYPE.INT, 2 },
		{ DATA_TYPE.WORD, 2 },
		{ DATA_TYPE.REAL, 4 },
		{ DATA_TYPE.STRING, 254 } // max string size
	};
	
	public static readonly Dictionary<DATA_TYPE, int> dataTypes = new Dictionary<DATA_TYPE, int>()
	{
		{ DATA_TYPE.BOOL, 0 },
		{ DATA_TYPE.INT, 1 },
		{ DATA_TYPE.WORD, 2 },
		{ DATA_TYPE.REAL, 3 },
		{ DATA_TYPE.STRING, 4 } // max string size
	};
	
	public int GetDataSize(DATA_TYPE type)
	{
		return dataSizes[type];
	}
	public int GetMemoryArea(MEM_AREAS type)
	{
		return memAreas[type];
	}

}
