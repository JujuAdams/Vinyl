// Feather disable all

function __VinylEditorPropertiesKnob(_contentDict, _contentName, _selectionHandler)
{
    var _contentData = _contentDict[$ _contentName];
    
    //Now do the actual table
    if (ImGui.BeginTable("Vinyl Properties", 2, ImGuiTableFlags.BordersOuter | ImGuiTableFlags.BordersInnerV | ImGuiTableFlags.ScrollY | ImGuiTableFlags.RowBg, undefined, 280))
    {
        //Set up our columns with fixed widths so we get a nice pretty layout
        ImGui.TableSetupColumn("Name",   ImGuiTableColumnFlags.WidthFixed, 100);
        ImGui.TableSetupColumn("Value",  ImGuiTableColumnFlags.WidthStretch, 1);
        
        
        
        ImGui.TableNextRow();
        ImGui.TableSetColumnIndex(0);
        ImGui.Text("Input Range");
        ImGui.TableSetColumnIndex(1);
        
        var _array = variable_clone(_contentData.__inputRange);
        ImGui.SetNextItemWidth(ImGui.GetColumnWidth(1));
        ImGui.InputFloat2("##Input Range", _array);
        if (ImGui.IsItemDeactivatedAfterEdit())
        {
            if (_array[0] > _array[1])
            {
                var _temp = _array[1];
                _array[1] = _array[0];
                _array[0] = _temp;
            }
            
            __VinylDocument().__Write(_contentData, "__inputRange", _array);
        }
        
        
        
        ImGui.TableNextRow();
        ImGui.TableSetColumnIndex(0);
        ImGui.Text("Output Range");
        ImGui.TableSetColumnIndex(1);
        
        var _array = variable_clone(_contentData.__outputRange);
        ImGui.SetNextItemWidth(ImGui.GetColumnWidth(1));
        ImGui.InputFloat2("##Output Range", _array);
        if (ImGui.IsItemDeactivatedAfterEdit())
        {
            if (_array[0] > _array[1])
            {
                var _temp = _array[1];
                _array[1] = _array[0];
                _array[0] = _temp;
            }
            
            __VinylDocument().__Write(_contentData, "__outputRange", _array);
            __VinylDocument().__Write(_contentData, "__defaultValue", clamp(_contentData.defaultValue, _contentData.outputRange[0], _contentData.outputRange[1]));
        }
        
        
        
        ImGui.TableNextRow();
        ImGui.TableSetColumnIndex(0);
        ImGui.Text("Default Value");
        ImGui.TableSetColumnIndex(1);
        
        ImGui.SetNextItemWidth(ImGui.GetColumnWidth(1));
        var _newValue = ImGui.InputFloat("##Default Value", _contentData.__defaultValue);
        if (ImGui.IsItemDeactivatedAfterEdit())
        {
            __VinylDocument().__Write(_contentData, "__defaultValue", clamp(_newValue, _contentData.outputRange[0], _contentData.outputRange[1]));
        }
        
        
        
        ImGui.EndTable();
    }
}