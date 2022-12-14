/// @param value

function VinylIsSoundInstance(_value)
{
    var _instanceof = instanceof(_value);
    if ((_instanceof == "__VinylInstanceBasic" )
    ||  (_instanceof == "__VinylInstanceLoop"  )
    ||  (_instanceof == "__VinylInstanceRandom")
    ||  (_instanceof == "__VinylInstanceQueue" )
    ||  (_instanceof == "__VinylInstanceMulti" ))
    {
        return true;
    }
    else
    {
        return false;
    }
}