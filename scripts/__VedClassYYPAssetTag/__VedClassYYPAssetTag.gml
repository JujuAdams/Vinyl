// Feather disable all

function __VedClassYYPAssetTag() constructor
{
    static _system = __VedSystem();
    
    __name = undefined;
    __soundNameArray = [];
    
    static __Add = function(_name)
    {
        array_push(__soundNameArray, _name);
    }
    
    static __Remove = function(_name)
    {
        var _index = __VedArrayFindIndex(__soundNameArray, _name);
        if (_index != undefined) array_delete(__soundNameArray, _index, 1);
    }
    
    static __CopyAssetArrayTo = function(_array)
    {
        array_copy(_array, array_length(_array), __soundNameArray, 0, array_length(__soundNameArray));
    }
}