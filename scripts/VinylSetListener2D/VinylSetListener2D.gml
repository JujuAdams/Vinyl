/// Set the position and orientation for Vinyl's listener. This function presumes that your game
/// is oriented with positive x values going rightwards across the screen and positive y values
/// going downwards. If you need more functionality, please use `VinylSetListener3D()`.
/// 
/// @param x
/// @param y

function VinylSetListener2D(_x, _y)
{
    return VinylSetListener3D(_x, _y, 0,   0, 0, 1,   0, 1, 0);
}