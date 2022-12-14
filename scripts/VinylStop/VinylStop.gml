/// @param vinylInstance

function VinylStop(_instance)
{
    if (!is_struct(_instance)) return;
    return _instance.Stop();
}