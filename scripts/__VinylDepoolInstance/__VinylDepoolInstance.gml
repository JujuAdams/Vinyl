function __VinylDepoolInstance()
{
	static _id = 0xF0000000;
	++_id;
	
	var _instance = array_pop(global.__vinylPool) ?? (new __VinylClassInstance());
	_instance.__id = _id;
    
    array_push(global.__vinylPlaying, _instance);
	global.__vinylInstanceIDs[? _id] = _instance;
	
	return _id;
}