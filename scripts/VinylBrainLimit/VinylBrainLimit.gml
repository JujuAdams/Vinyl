/// Example:
///     ///Create Event
///     brain = new VinylBrainLimit(5);
/// 
///     ///Step Event
///     if (keyboard_check_pressed(vk_space))
///     {
///         //The incoming voice will only be played if there are less than 5 playing voices
///         brain.Push(VinylPlayOmni(sndExample));
///     }
/// 
/// Methods for this brain:
/// 
/// `.Push(voice)`
///     Pushes a voice to the brain. If there is no space in the brain for the new voice then
///     the new voice is stopped immediately.
/// 
/// `.GetAllowed()`
///     Returns whether there is space in the brain for a new voice.
/// 
/// `.ForcePush(voice)`
///     Pushes a voice to the brain without considering whether there is space or not.
/// 
/// `.SetMaxCount(maxCount)`
///     Sets the maximum number of voices that can be played simultaneously for this brain. If
///     there are more voices playing than allowed then this function will *not* stop the extra
///     voices.
/// 
/// `.GetMaxCount()`
///     Returns the maximum number of voices that can be played simultaneously for this brain.
/// 
/// @param maxCount

function VinylBrainLimit(_maxCount) : VinylBrainParentConstructor(false) constructor
{
    __maxCount = _maxCount;
    __watchArray = [];
    
    static Push = function(_voice)
    {
        if (GetAllowed())
        {
            array_push(__watchArray, _voice);
            return _voice;
        }
        else
        {
            VinylStop(_voice);
            return -1;
        }
    }
    
    static GetAllowed = function()
    {
        var _watchArray = __watchArray;
        var _i = array_length(_watchArray)-1;
        repeat(_i+1)
        {
            if (VinylGetStopped(_watchArray[_i]))
            {
                array_delete(_watchArray, _i, 1);
            }
            
            --_i;
        }
        
        return (array_length(_watchArray) < __maxCount);
    }
    
    static ForcePush = function(_voice)
    {
        array_push(__watchArray, _voice);
        return _voice;
    }
    
    static SetMaxCount = function(_maxCount)
    {
        __maxCount = _maxCount;
        GetAllowed();
        
        return self;
    }
    
    return GetMaxCount = function()
    {
        return __maxCount;
    }
}