function __VinylTick()
{
    static _globalData = __VinylGlobalData();
    static _topLevelArray = _globalData.__topLevelArray;
    
    //Unpack pools
    static _poolGameMaker = _globalData.__poolGameMaker;
    static _poolBasic     = _globalData.__poolBasic;
    static _poolQueue     = _globalData.__poolQueue;
    static _poolMulti     = _globalData.__poolMulti;
    static _poolEmitter   = _globalData.__poolEmitter;
    //Don't tick the pan emitters - we only need to update those when the listener changes position
    
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
    
    //Tick everything active in our pools
    _poolGameMaker.__Tick(_deltaTimeFactor);
    _poolBasic.__Tick(_deltaTimeFactor);
    _poolQueue.__Tick(_deltaTimeFactor);
    _poolMulti.__Tick(_deltaTimeFactor);
    _poolEmitter.__Tick(_deltaTimeFactor);
    
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
}