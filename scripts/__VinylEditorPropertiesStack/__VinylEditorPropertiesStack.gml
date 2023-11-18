// Feather disable all

function __VinylEditorPropertiesStack(_contentDict, _contentName, _selectionHandler)
{
    var _contentData = _contentDict[$ _contentName];
    
    //Now do the actual table
    if (ImGui.BeginTable("Vinyl Properties", 2, ImGuiTableFlags.BordersOuter | ImGuiTableFlags.BordersInnerV | ImGuiTableFlags.ScrollY | ImGuiTableFlags.RowBg, undefined, 280))
    {
        //Set up our columns with fixed widths so we get a nice pretty layout
        ImGui.TableSetupColumn("Name",   ImGuiTableColumnFlags.WidthFixed, 160);
        ImGui.TableSetupColumn("Value",  ImGuiTableColumnFlags.WidthStretch, 1);
        
        ImGui.TableNextRow();
        ImGui.TableSetColumnIndex(0);
        ImGui.Text("Ducked Gain");
        ImGui.TableSetColumnIndex(1);
        __VinylDocument().__Write(_contentData, "__duckedGain", ImGui.SliderFloat("##Ducked Gain", _contentData.__duckedGain, 0, 1, "%.2f"));
        
        ImGui.TableNextRow();
        ImGui.TableSetColumnIndex(0);
        ImGui.Text("Duck Rate (gain/sec.)");
        ImGui.TableSetColumnIndex(1);
        __VinylDocument().__Write(_contentData, "__duckRate", ImGui.SliderFloat("##Ducked Rate", _contentData.__duckRate, 0.1, 10, "%.2f"));
        
        ImGui.TableNextRow();
        ImGui.TableSetColumnIndex(0);
        ImGui.Text("Pause When Ducked");
        ImGui.TableSetColumnIndex(1);
        __VinylDocument().__Write(_contentData, "__pauseWhenDucked", ImGui.Checkbox("##Ducked Gain", _contentData.__pauseWhenDucked, 0, 1, "%.2f"));
        
        ImGui.EndTable();
    }
}