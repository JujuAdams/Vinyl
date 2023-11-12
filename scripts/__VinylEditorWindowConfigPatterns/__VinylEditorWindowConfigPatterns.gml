// Feather disable all

function __VinylEditorWindowConfigPatterns(_stateStruct)
{
    var _tabState = _stateStruct.__tabPatterns;
    
    var _resourceTypeName = "Pattern";
    var _resourceConstructor = __VinylClassPatternNew;
    var _resourceDict = __VinylDocument().__data.patterns;
    
    var _resourceNameArray = variable_struct_get_names(_resourceDict);
    array_sort(_resourceNameArray, true);
    
    //Bit of aesthetic spacing
    ImGui.SetCursorPosY(ImGui.GetCursorPosY() + 5);
    
    if (ImGui.Button("Add"))
    {
        __VinylEditorSharedAdd(_resourceDict, _resourceTypeName, _resourceConstructor);
    }
    
    ImGui.SameLine(undefined, 40);
    _tabState.__quickDelete = ImGui.Checkbox("Quick Delete", _tabState.__quickDelete);
    
    //Little more aesthetic spacing
    ImGui.SetCursorPosY(ImGui.GetCursorPosY() + 5);
    
    //Now do the actual table
    if (ImGui.BeginTable("Table", 4, ImGuiTableFlags.BordersOuter | ImGuiTableFlags.BordersInnerV | ImGuiTableFlags.ScrollY | ImGuiTableFlags.RowBg, undefined, ImGui.GetContentRegionAvailY()))
    {
        //Set up our columns with fixed widths so we get a nice pretty layout
        ImGui.TableSetupColumn(_resourceTypeName, ImGuiTableColumnFlags.WidthStretch, 1);
        ImGui.TableSetupColumn("Delete", ImGuiTableColumnFlags.WidthFixed, 70);
        ImGui.TableSetupColumn("Option", ImGuiTableColumnFlags.WidthFixed, 150);
        ImGui.TableSetupColumn("Value", ImGuiTableColumnFlags.WidthStretch, 1);
        
        //Populate the table with lots of nodes
        var _i = 0;
        repeat(array_length(_resourceNameArray))
        {
            var _name = _resourceNameArray[_i];
            __VinylEditorPropertiesPattern(_stateStruct, _name, undefined, undefined, _name, _resourceDict[$ _name], _resourceConstructor);
            ++_i;
        }
        
        ImGui.EndTable();
    }
}