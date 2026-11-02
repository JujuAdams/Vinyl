/// Updates a callback once every frame for as long as a voice is playing. When the voice stops
/// playing, the callback is executed one last time and then the callback is never called again.
/// If an array of voices is provided, the callback will be executed for as long as any of the
/// voices are playing.
/// 
/// @param voiceOrArray
/// @param data
/// @param callback

function VinylBrainTick(_voiceOrArray, _data, _callback) : VinylBrainParentConstructor(false) constructor
{
    static __brainInterface = false;
    
    __voiceOrArray = _voiceOrArray;
    __data         = _data;
    __callback     = _callback;
    
    __method = function()
    {
        if (VinylGetPlaying(__voiceOrArray))
        {
            return __callback(__data, __voiceOrArray, true);
        }
        else
        {
            __callback(__data, __voiceOrArray, false);
            return false;
        }
    };
    
    array_push(__VinylSystem().__strongUpdateArray, __method);
    
    static GetVoice = function()
    {
        return __voice;
    }
    
    static SetData = function(_data)
    {
        __data = _data;
        
        return self;
    }
    
    static GetData = function()
    {
        return __data;
    }
    
    static Cancel = function(_executeCallback = false)
    {
        var _array = __VinylSystem().__strongUpdateArray;
        var _index = array_get_index(_array, __method);
        if (_index >= 0) array_delete(_array, _index, 1);
        
        if (_executeCallback)
        {
            __callback(__data, __voiceOrArray, false);
        }
    }
}