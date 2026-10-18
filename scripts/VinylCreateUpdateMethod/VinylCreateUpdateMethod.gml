/// @param voiceOrArray
/// @param data
/// @param method

function VinylCreateUpdateMethod(_voiceOrArray, _data, _method)
{
    static _strongUpdateArray = __VinylSystem().__strongUpdateArray;
    
    array_push(_strongUpdateArray, method({
        __voiceOrArray: _voiceOrArray,
        __data: _data,
        __method: _method,
    },
    function()
    {
        if (VinylGetAnyPlaying(__voiceOrArray))
        {
            return __method(__data, __voiceOrArray, true);
        }
        else
        {
            __method(__data, __voiceOrArray, false);
            return false;
        }
    }));
}