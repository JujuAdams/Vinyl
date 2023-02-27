function __VinylTick()
{
    static _globalData = __VinylGlobalData();
    
    ++_globalData.__frame;
    var _deltaTimeFactor = (delta_time / (game_get_speed(gamespeed_fps)*game_get_speed(gamespeed_microseconds)));
    
    //Update knobs
    var _knobArray = _globalData.__knobArray; //Don't use a static here because this struct can be recreated
    var _i = 0;
    repeat(array_length(_knobArray))
    {
        _knobArray[_i].__Tick(_deltaTimeFactor);
        ++_i;
    }
    
    //Update labels
    var _labelOrder = _globalData.__labelOrder; //Don't use a static here because this struct can be recreated
    var _i = 0;
    repeat(array_length(_labelOrder))
    {
        _labelOrder[_i].__Tick(_deltaTimeFactor);
        ++_i;
    }
    
    //Update stacks
    static _stackArray = _globalData.__stackArray;
    var _i = 0;
    repeat(array_length(_stackArray))
    {
        _stackArray[_i].__Tick();
        ++_i;
    }
    
    //Update top-level instances. Each top-level instance then updates its children
    static _topLevelArray = _globalData.__topLevelArray;
    var _i = 0;
    repeat(array_length(_topLevelArray))
    {
        var _instance = _topLevelArray[_i];
        if (_instance.__pool != undefined)
        {
            _instance.__Tick(_deltaTimeFactor);
            ++_i;
        }
        else
        {
            array_delete(_topLevelArray, _i, 1);
        }
    }
    
    //Update our pools. This ensures structs in the return array get shifted over into the active array
    static _poolAsset      = _globalData.__poolAsset;
    static _poolBasic      = _globalData.__poolBasic;
    static _poolQueue      = _globalData.__poolQueue;
    static _poolMulti      = _globalData.__poolMulti;
    static _poolEmitter    = _globalData.__poolEmitter;
    static _poolPanEmitter = _globalData.__poolPanEmitter;
    
    _poolAsset.__Tick();
    _poolBasic.__Tick();
    _poolQueue.__Tick();
    _poolMulti.__Tick();
    _poolEmitter.__Tick();
    _poolPanEmitter.__Tick();
}