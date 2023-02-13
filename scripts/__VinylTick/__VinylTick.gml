function __VinylTick()
{
    static _globalData = __VinylGlobalData();
    
    //Unpack pools
    static _poolBasic   = _globalData.__poolBasic;
    static _poolEmitter = _globalData.__poolEmitter;
    //Don't tick the pan emitters - we only need to update those when the listener changes position
    
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
    _poolBasic.__Tick(_deltaTimeFactor);
    _poolEmitter.__Tick(_deltaTimeFactor);
}