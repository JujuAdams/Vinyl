/// @param startingId
/// @param constructor

function __VinylClassPool(_startingID, _constructor) constructor
{
    __constructor = _constructor;
    __id          = int64(_startingID);
    __poolArray   = [];
    __activeArray = [];
    __returnArray = [];
    
    static toString = function()
    {
        return "<pool " + string(script_get_name(__constructor)) + ">";
    }
    
    static __Populate = function(_count)
    {
        if (VINYL_DEBUG_LEVEL >= 1) __VinylTrace("Populating ", self, " with ", _count, " members");
        repeat(_count) array_push(__poolArray, new __constructor());
    }
    
    static __Return = function(_member, _safe = false)
    {
        if (_safe)
        {
            var _i = 0;
            repeat(array_length(__activeArray))
            {
                if (__activeArray[_i] == _member)
                {
                    array_delete(__activeArray, _i, 1);
                    break;
                }
                
                ++_i;
            }
        }
        
        _member.__id = undefined;
        _member.__pooled = true;
        array_push(__returnArray, _member);
    }
    
    static __Depool = function()
    {
        ++__id;
        
        var _member = array_pop(__poolArray);
        if (_member == undefined)
        {
            __VinylTrace(self, " empty, creating new member");
            _member = new __constructor();
        }
        
        array_push(__activeArray, _member);
        _member.__id = __id;
        _member.__pooled = false;
        _member.__Depool();
        
        return __id;
    }
    
    static __Tick = function(_deltaTimeFactor)
    {
        var _returnSize = array_length(__returnArray);
        if (_returnSize > 0)
        {
            var _poolSize = array_length(__poolArray);
            array_resize(__poolArray, _poolSize + _returnSize);
            array_copy(__poolArray, _poolSize, __returnArray, 0, _returnSize);
            array_resize(__returnArray, 0);
            
            if (VINYL_DEBUG_LEVEL >= 1) __VinylTrace("Returned ", _returnSize, " member(s) to ", self, ", ", _poolSize + _returnSize, " members now in pool");
        }
        
        var _i = 0;
        repeat(array_length(__activeArray))
        {
            var _instance = __activeArray[_i];
            if (_instance.__pooled)
            {
                array_delete(__activeArray, _i, 1);
            }
            else
            {
                _instance.__Tick(_deltaTimeFactor);
                ++_i;
            }
        }
    }
}