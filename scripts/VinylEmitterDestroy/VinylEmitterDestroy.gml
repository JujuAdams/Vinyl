/// @param emitter

function VinylEmitterDestroy(_emitter)
{
    static _emitterPoolReturn = __VinylGlobalData().__emitterPoolReturn;
    
    var _i = 0;
    repeat(array_length(_emitterPoolReturn))
    {
        if (_emitterPoolReturn[_i] == _emitter) return;
        ++_i;
    }
    
    array_push(_emitterPoolReturn, _emitter);
}