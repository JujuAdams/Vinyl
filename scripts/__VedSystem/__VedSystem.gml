// Feather disable all

#macro __VED_VERSION  "6.0.0"
#macro __VED_DATE     "2024-03-14"

#macro __VED_RUNNING_FROM_IDE  (GM_build_type == "run")
#macro __VED_ENABLED  (VED_ENABLED && (os_type == os_windows) && __VED_RUNNING_FROM_IDE)

#macro __VED_NEXT_UI_FILLS_WIDTH  ImGui.SetNextItemWidth(ImGui.GetContentRegionAvailX());
#macro __VED_UNDERLINE_PREV_TEXT  ImGui.DrawListAddLine(ImGui.GetWindowDrawList(), ImGui.GetItemRectMinX(), ImGui.GetItemRectMaxY(), ImGui.GetItemRectMaxX(), ImGui.GetItemRectMaxY(), c_white);

function __VedSystem()
{
    static _system = undefined;
    if (_system != undefined) return _system;
    _system = {};
    
    with(_system)
    {
        __frame = 0;
        __VedTrace("Welcome to Vinyl Editor! This is version ", __VED_VERSION, ", ", __VED_DATE);
        
        __ImGuiBoot();
        
        __showing = false;
        
        __windowsArray = [];
        array_push(__windowsArray, new __VedClassDesktop());
        
        time_source_start(time_source_create(time_source_global, 1, time_source_units_frames, __VedUpdate, [], -1));
    }
    
    return _system;
}