#include "snap7_wrapper.h"
#include <godot_cpp/variant/utility_functions.hpp>
#include <godot_cpp/core/class_db.hpp>

int Snap7Wrapper::ConnectToPLC(String ip, int rack, int slot) {
	std::string sip = ip.utf8().get_data(); 
	return client.ConnectTo(sip.c_str(), rack, slot);
}

int Snap7Wrapper::IsConnected() {
	return client.Connected();
}

void Snap7Wrapper::Test() {
	UtilityFunctions::print("hello from c++");
}

void Snap7Wrapper::_bind_methods() {
	ClassDB::bind_method(D_METHOD("Test"), &Snap7Wrapper::Test);
	ClassDB::bind_method(D_METHOD("IsConnected"), &Snap7Wrapper::IsConnected);
	ClassDB::bind_method(D_METHOD("ConnectToPLC", "ip", "rack", "slot"), &Snap7Wrapper::ConnectToPLC);
}
