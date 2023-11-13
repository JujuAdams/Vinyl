// Feather disable all

function __VinylSerializePatternArray(_inputArray)
{
    var _outputArray = [];
    
    var _i = 0;
    repeat(array_length(_inputArray))
    {
        array_push(_outputArray, _inputArray[_i].__Serialize({}));
        ++_i;
    }
    
    return _outputArray;
}