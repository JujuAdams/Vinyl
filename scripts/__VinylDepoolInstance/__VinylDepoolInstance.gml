function __VinylDepoolInstance()
{
	static _id = 0xF0000000;
	++_id;
	
	var _instance = array_pop(global.__vinylPool);
	if (_instance == undefined)
	{
		__VinylTrace("No instances in pool, creating a new one");
		_instance = new __VinylClassInstance();
	}
	
	_instance.__Depool(_id);
	return _id;
}