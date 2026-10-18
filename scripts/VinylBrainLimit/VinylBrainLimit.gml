/// @param maxCount

function VinylBrainLimit(_maxCount) : __VinylClassBrainInterface() constructor
{
    __maxCount = _maxCount;
    __watchArray = [];
    
    static GetAllowed = function()
    {
        var _watchArray = __watchArray;
        var _i = array_length(_watchArray)-1;
        repeat(_i+1)
        {
            if (not audio_is_playing(_watchArray[_i]))
            {
                array_delete(_watchArray, _i, 1);
            }
            
            --_i;
        }
        
        return (array_length(_watchArray) < __maxCount);
    }
    
    static Push = function(_voice)
    {
        array_push(__watchArray, _voice);
        return _voice;
    }
    
    static PlayOmni = function(_sound, _gain = 1, _pitch = 1)
    {
        if (GetAllowed())
        {
            var _voice =  VinylPlayOmni(_sound, _gain, _pitch);
            array_push(__watchArray, _voice);
            return _voice;
        }
        else
        {
            return -1;
        }
    }
    
    static PlayAt = function(_sound, _x, _y, _z, _gain = 1, _pitch = 1)
    {
        if (GetAllowed())
        {
            var _voice =  VinylPlayAt(_sound, _x, _y, _z, _gain, _pitch);
            array_push(__watchArray, _voice);
            return _voice;
        }
        else
        {
            return -1;
        }
    }
    
    static PlayOn = function(_emitter, _sound, _gain = 1, _pitch = 1)
    {
        if (GetAllowed())
        {
            var _voice =  VinylPlayOn(_sound, _emitter, _gain, _pitch);
            array_push(__watchArray, _voice);
            return _voice;
        }
        else
        {
            return -1;
        }
    }
}