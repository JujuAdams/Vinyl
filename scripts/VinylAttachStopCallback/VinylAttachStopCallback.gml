/// @param voiceOrArray
/// @param data
/// @param method

function VinylAttachStopCallback(_voiceOrArray, _data, _method)
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
            return true;
        }
        else
        {
            __method(__data, __voiceOrArray);
            return false;
        }
    }));
}