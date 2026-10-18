/// @param soundAsset

function __VinylClassSoundDef(_soundAsset) constructor
{
    static _system = __VinylSystem();
    
    __sound         = _sound;
    __mixGroupIndex = undefined;
    __gain          = undefined;
    __otherData     = undefined;
    
    static __Update = function(_mixGroupIndex, _gain, _otherData)
    {
        with(__VinylGetMixGroup(__mixGroupIndex))
        {
            var _index = array_get_index(__soundArray, self);
            if (_index >= 0) array_delete(__soundArray, _index, 1);
        }
        
        var _mixGroup = __VinylGetMixGroup(_mixGroupIndex);
        if (_mixGroup == undefined)
        {
            __VinylError($"Mix group not defined or mix group `{_mixGroupIndex}` is invalid");
            return;
        }
        
        array_push(_mixGroup.__soundArray, self);
        __mixGroupIndex = _mixGroupIndex;
        
        __gain = _gain;
        __otherData = _otherData;
    }
}