function __VinylDepoolInstance()
{
	static _id = 0xF0000000;
	++_id;
	
    if (array_length(global.__vinylPool) > 0)
    {
        var _instance = global.__vinylPool[0];
        array_delete(global.__vinylPool, 0, 1);
    }
    else
    {
        var _instance = new __VinylClassInstance();
    }
	
	_instance.__id = _id;
    
    array_push(global.__vinylPlaying, _instance);
	global.__vinylInstances[? _id] = _instance;
	
	return _id;
}