function __VinylArrayDuplicate(_inArray)
{
    var _size = array_length(_inArray);
    var _outArray = array_create(_size, undefined);
    array_copy(_outArray, 0, _inArray, 0, _size);
    return _outArray;
}