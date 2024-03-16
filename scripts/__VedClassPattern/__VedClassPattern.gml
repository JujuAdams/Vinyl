// Feather disable all

function __VedClassPattern() constructor
{
    __name = undefined;
    
    static __CompilePlay = function(_buffer)
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