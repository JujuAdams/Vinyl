/// Constructor. Creates a struct that can be used to restrict how many voices are playing at the
/// same time.
/// 
/// Example:
///     /// Create Event
///     logic = new VinylLogicLimit(5);
/// 
///     ///Step Event
///     if (keyboard_check_pressed(vk_space))
///     {
///         //The incoming voice will only be played if there are less than 5 playing voices
///         logic.Push(VinylPlay(sndExample));
///     }
/// 
/// Methods for this logic:
/// 
/// `.Push(voice)`
///     Pushes a voice to the logic. If there is no space in the logic for the new voice then
///     the new voice is stopped immediately.
/// 
/// `.GetAllowed()`
///     Returns whether there is space in the logic for a new voice.
/// 
/// `.ForcePush(voice)`
///     Pushes a voice to the logic without considering whether there is space or not.
/// 
/// `.SetMaxCount(maxCount)`
///     Sets the maximum number of voices that can be played simultaneously for this logic. If
///     there are more voices playing than allowed then this function will *not* stop the extra
///     voices.
/// 
/// `.GetMaxCount()`
///     Returns the maximum number of voices that can be played simultaneously for this logic.
/// 
/// @param maxCount

function VinylLogicLimit(_maxCount) : VinylLogicParentConstructor(false) constructor
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
    
    static __CleanUp = function()
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
    }
    
    static GetCount = function()
    {
        __CleanUp();
        return array_length(__watchArray);
    }
    
    static GetAllowed = function()
    {
        __CleanUp();
        return (array_length(__watchArray) < __maxCount);
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
    
    static GetMaxCount = function()
    {
        return __maxCount;
    }
    
    
    
    
    
    static ImplGetAllPlaying = function()
    {
        __CleanUp();
        return (array_length(__watchArray) > 0);
    }
    
    static ImplGetPlaying = function()
    {
        __CleanUp();
        return (array_length(__watchArray) > 0);
    }
}