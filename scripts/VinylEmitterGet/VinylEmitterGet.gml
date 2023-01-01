/// @param instance

function VinylEmitterGet(_id)
{
    var _instance = global.__vinylIdToInstanceDict[? _id];
    return is_struct(_instance)? _instance.__emitter : undefined;
}