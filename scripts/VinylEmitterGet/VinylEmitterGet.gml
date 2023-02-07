/// @param instance

function VinylEmitterGet(_id)
{
    static _idToInstanceDict = __VinylGlobalData().__idToInstanceDict;
    var _instance = _idToInstanceDict[? _id];
    return is_struct(_instance)? _instance.__emitter : undefined;
}