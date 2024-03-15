// Feather disable all

function __VedClassYYPAsset() constructor
{
    __partialPath  = undefined;
    __absolutePath = undefined;
    __name         = undefined;
    __known        = false;
    
    static __GetName = function()
    {
        return __name;
    }
    
    static __Compile = function(_buffer)
    {
        __VedError("Cannot compile .yyp asset");
    }
    
    static __GenerateVinylAsset = function()
    {
        var _new = new __VedClassVinylAsset();
        _new.__name = __name;
        return _new;
    }
}