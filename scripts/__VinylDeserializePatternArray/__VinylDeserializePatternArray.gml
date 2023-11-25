// Feather disable all

/// @param array
/// @param document

function __VinylDeserializePatternArray(_inputArray, _document)
{
    var _outputArray = [];    
    
    var _i = 0;
    repeat(array_length(_inputArray))
    {
        var _input = _inputArray[_i];
        __VinylTrace("Deserializing ", _input.uuid);
        
        var _constructor = __VinylConvertPatternNameToConstructor(_input.type, _input.uuid);
        
        var _new = new _constructor();
        _new.__Deserialize(_input);
        
        if (_document != undefined)
        {
            _new.__Store(_document);
        }
        
        ++_i;
    }
    
    return _outputArray;
}