// Feather disable all

function __VinylGetProjectPath()
{
    static _result = filename_dir(GM_project_filename) + "/" + __VINYL_PROJECT_FILENAME;
    return _result;
}