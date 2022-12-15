function __VinylDepoolInstance()
{
	static _id = 0xF0000000;
	++_id;
	(array_pop(global.__vinylPool) ?? (new __VinylClassInstance())).__Depool(_id);
	return _id;
}