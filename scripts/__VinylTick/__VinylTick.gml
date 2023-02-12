function __VinylTick()
{
    static _globalData = __VinylGlobalData();
    
    //Unpack pools
    static _poolBasic      = _globalData.__poolBasic;
    static _poolQueue      = _globalData.__poolQueue;
    static _poolBlend      = _globalData.__poolBlend;
    static _poolEmitter    = _globalData.__poolEmitter;
    static _poolPanEmitter = _globalData.__poolPanEmitter;
    
    var _deltaTimeFactor = (delta_time / (game_get_speed(gamespeed_fps)*game_get_speed(gamespeed_microseconds)));
    
    //Update labels first
    var _labelOrder = _globalData.__labelOrder; //Don't use a static here because this struct can be recreated
    var _i = 0;
    repeat(array_length(_labelOrder))
    {
        _labelOrder[_i].__Tick(_deltaTimeFactor);
        ++_i;
    }
    
    _poolBasic.__Tick(_deltaTimeFactor);
    _poolQueue.__Tick(_deltaTimeFactor);
    _poolBlend.__Tick(_deltaTimeFactor);
    _poolEmitter.__Tick(_deltaTimeFactor);
    _poolPanEmitter.__Tick(_deltaTimeFactor);
}