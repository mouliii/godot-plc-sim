using Godot;
using System;
using System.Runtime.InteropServices;
using System.Security.AccessControl;

public partial class script_commcs : Node
{


	// Called when the node enters the scene tree for the first time.
	public override void _Ready()
	{
		var myGDScript = GD.Load<GDScript>("uid://cycutc40h5tr");
		var myGDScriptNode = (GodotObject)myGDScript.New(); // This is a GodotObject.
		//GD.Print(myGDScriptNode.DATA.BOOL);
	}

	// Called every frame. 'delta' is the elapsed time since the previous frame.
	public override void _Process(double delta)
	{
	}
}
