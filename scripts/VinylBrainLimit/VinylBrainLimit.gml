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
            if (VinylGetAllStopped(_watchArray[_i]))
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
}