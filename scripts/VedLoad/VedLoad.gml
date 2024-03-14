// Feather disable all

/// @param projectPath
/// @param [showEditor=true]

function VedLoad(_projectPath, _show = true)
{
    static _system = __VedSystem();
    
    VedUnload();
    _system.__project = new __VedClassProject();
    _system.__project.__Load(_projectPath);
    
    if (_show) VedShow();
}