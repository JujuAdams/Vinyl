// Feather disable all

function __VedClassVinylAsset() constructor
{
    __partialPath  = undefined;
    __absolutePath = undefined;
    __name         = undefined;
    
    static __Compile = function(_buffer)
    {
        
    }
    
    static __Serialize = function(_array)
    {
        array_push(_array, {
            name: __name,
        });
    }
    
    static __Deserialize = function(_data)
    {
        __name = _data.name;
    }
}