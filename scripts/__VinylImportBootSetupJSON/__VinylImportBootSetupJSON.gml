// Feather disable all

function __VinylImportBootSetupJSON()
{
    if (VINYL_LIVE_EDIT)
    {
        var _buffer = buffer_load(filename_dir(GM_project_filename) + "/scripts/__VinylConfigBootSetupJSON/__VinylConfigBootSetupJSON.gml");
        var _gml = SnapBufferReadGML(_buffer, 0, buffer_get_size(_buffer));
        buffer_delete(_buffer);
        
        VinylSetupImportJSON(_gml[$ "global.VinylBootSetupJSON"] ?? []);
    }
}