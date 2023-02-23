function __VinylTick()
{
    static _globalData = __VinylGlobalData();
    
    ++_globalData.__frame;
    var _deltaTimeFactor = (delta_time / (game_get_speed(gamespeed_fps)*game_get_speed(gamespeed_microseconds)));
    
    //Update labels first
    var _labelOrder = _globalData.__labelOrder; //Don't use a static here because this struct can be recreated
    var _i = 0;
    repeat(array_length(_labelOrder))
    {
        _labelOrder[_i].__Tick(_deltaTimeFactor);
        ++_i;
    }
    
    //Update top-level instances. Each top-level instance then updates its children
    static _topLevelArray = _globalData.__topLevelArray;
    var _i = 0;
    repeat(array_length(_topLevelArray))
    {
        var _instance = _topLevelArray[_i];
        if (_instance.__IsPlaying())
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
    static _poolGameMaker  = _globalData.__poolGameMaker;
    static _poolBasic      = _globalData.__poolBasic;
    static _poolQueue      = _globalData.__poolQueue;
    static _poolMulti      = _globalData.__poolMulti;
    static _poolEmitter    = _globalData.__poolEmitter;
    static _poolPanEmitter = _globalData.__poolPanEmitter;
    
    _poolGameMaker.__Tick();
    _poolBasic.__Tick();
    _poolQueue.__Tick();
    _poolMulti.__Tick();
    _poolEmitter.__Tick();
    _poolPanEmitter.__Tick();
}