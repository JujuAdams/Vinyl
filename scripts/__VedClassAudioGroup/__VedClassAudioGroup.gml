// Feather disable all

function __VedClassAudioGroup() constructor
{
    static _system = __VedSystem();
    
    __name = undefined;
    __target = -1;
    
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
    
    static __MoveAllToDefault = function()
    {
        var _soundDict = _system.__project.__libYYPAsset.__GetDictionary();
        
        var _i = array_length(__soundNameArray)-1;
        repeat(array_length(__soundNameArray))
        {
            var _name = __soundNameArray[_i];
            
            var _sound = _soundDict[$ _name];
            if (_sound != undefined) _sound.__SetAudioGroup(__VED_DEFAULT_AUDIO_GROUP);
            
            --_i;
        }
        
        array_resize(__soundNameArray, 0);
    }
}