// Feather disable all

/// @param array
/// @param constructor
/// @param document
/// @param parent

function __VinylDeserializeArray(_inputArray, _constructor, _document, _parent)
{
    var _outputArray = [];    
    
    var _i = 0;
    repeat(array_length(_inputArray))
    {
        var _input = _inputArray[_i];
        
        var _new = new _constructor();
        _new.__Deserialize(_input, _parent);
        
        if (_document != undefined)
        {
            _new.__Store(_document);
        }
        
        ++_i;
    }
    
    return _outputArray;
}