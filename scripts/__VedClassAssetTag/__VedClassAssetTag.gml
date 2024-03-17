// Feather disable all

function __VedClassAssetTag() constructor
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
    
    static __RemoveFromAll = function()
    {
        var _soundDict = _system.__project.__libSound.__GetDictionary();
        
        var _i = array_length(__soundNameArray)-1;
        repeat(array_length(__soundNameArray))
        {
            _soundDict[$ __soundNameArray[_i]].__SetAssetTag(__name, false);
            --_i;
        }
    }
    
    static __CopyAssetArrayTo = function(_array)
    {
        array_copy(_array, array_length(_array), __soundNameArray, 0, array_length(__soundNameArray));
    }
}