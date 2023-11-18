// Feather disable all

function __VinylEditorPropertiesEffectChain(_contentDict, _contentName, _selectionHandler)
{
    var _contentData = _contentDict[$ _contentName];
    
    //Now do the actual table
    if (ImGui.BeginTable("Vinyl Properties", 2, ImGuiTableFlags.BordersOuter | ImGuiTableFlags.BordersInnerV | ImGuiTableFlags.ScrollY | ImGuiTableFlags.RowBg, undefined, 280))
    {
        //Set up our columns with fixed widths so we get a nice pretty layout
        ImGui.TableSetupColumn("Name",   ImGuiTableColumnFlags.WidthFixed, 160);
        ImGui.TableSetupColumn("Value",  ImGuiTableColumnFlags.WidthStretch, 1);
        
        ImGui.EndTable();
    }
}