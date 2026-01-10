#pragma once
#include <godot_cpp/classes/node.hpp>
#include "snap7.h"
#include <godot_cpp/variant/string.hpp>

using namespace godot;

class Snap7Wrapper: public Node
{
	GDCLASS(Snap7Wrapper, Node);

public:
	Snap7Wrapper() = default;
	~Snap7Wrapper() override = default;
	int ConnectToPLC(String ip, int rack, int slot);
	int IsConnected();
	void Test();

private:
	TS7Client client;

protected:
	static void _bind_methods();
};
