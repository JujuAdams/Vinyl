/// @param value

function VinylIsSoundInstance(_value)
{
    var _instanceof = instanceof(_value);
    if ((_instanceof == "__VinyInstanceBasic" )
    ||  (_instanceof == "__VinyInstanceLoop"  )
    ||  (_instanceof == "__VinyInstanceRandom")
    ||  (_instanceof == "__VinyInstanceQueue" )
    ||  (_instanceof == "__VinyInstanceMulti" ))
    {
        return true;
    }
    else
    {
        return false;
    }
}