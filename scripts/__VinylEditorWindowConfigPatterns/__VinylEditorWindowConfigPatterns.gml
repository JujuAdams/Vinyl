// Feather disable all

function __VinylEditorWindowConfigPatterns(_stateStruct)
{
    static _editor = __VinylGlobalData().__editor;
    if (not VinylEditorIsShowing()) return;
    
    ImGui.SetNextWindowSize(0.7*room_width, 0.8*room_height, ImGuiCond.Once);
    ImGui.SetNextWindowPos(0.15*room_width, 0.1*room_height, ImGuiCond.Once);
	
    var ret = ImGui.Begin("Patterns", __VinylEditorWindowGetOpen("__configPatterns"), undefined, ImGuiReturnMask.Both);
    __VinylEditorWindowSetOpen("__configPatterns", (ret & ImGuiReturnMask.Pointer));
    
    if (ret & ImGuiReturnMask.Return)
    {
		if (ImGui.BeginTabBar("Tab Bar"))
        {
            if (ImGui.BeginTabItem("Assets"))
            {
                ImGui.EndTabItem();
            }
            
            if (ImGui.BeginTabItem("Labels"))
            {
                ImGui.EndTabItem();
            }
                
            if (ImGui.BeginTabItem("Patterns"))
            {
                var _resourceTypeName = "Pattern";
                var _resourceConstructor = __VinylClassPatternNew;
                var _resourceDict = __VinylDocument().__data.patterns;
        
                var _resourceNameArray = variable_struct_get_names(_resourceDict);
                array_sort(_resourceNameArray, true);
        
        		var _height = ImGui.GetContentRegionAvailY();
        
                if (ImGui.Button("Add"))
                {
                    __VinylEditorSharedAdd(_resourceDict, _resourceTypeName, _resourceConstructor);
                }
                
                ImGui.SameLine(undefined, 40);
                _stateStruct.__quickDelete = ImGui.Checkbox("Quick Delete", _stateStruct.__quickDelete);
                
                //Now do the actual table
                if (ImGui.BeginTable("Table", 4, ImGuiTableFlags.BordersOuter | ImGuiTableFlags.BordersInnerV | ImGuiTableFlags.ScrollY, undefined, _height - 23))
                {
                    //Set up our columns with fixed widths so we get a nice pretty layout
                    ImGui.TableSetupColumn(_resourceTypeName, ImGuiTableColumnFlags.WidthStretch, 1);
                    ImGui.TableSetupColumn("Delete", ImGuiTableColumnFlags.WidthFixed, 70);
                    ImGui.TableSetupColumn("Value", ImGuiTableColumnFlags.WidthStretch, 1);
                    ImGui.TableSetupColumn("Option", ImGuiTableColumnFlags.WidthFixed, 150);
                    
                    //Populate the table with lots of nodes
                    var _i = 0;
                    repeat(array_length(_resourceNameArray))
                    {
                        var _name = _resourceNameArray[_i];
                        __VinylEditorPropertiesPattern(_name, undefined, undefined, _name, _resourceDict[$ _name], _resourceConstructor);
                        ++_i;
                    }
                    
                    ImGui.EndTable();
                }
                
                ImGui.EndTabItem();
            }
            
            if (ImGui.BeginTabItem("Stacks"))
            {
                ImGui.EndTabItem();
            }
            
            if (ImGui.BeginTabItem("Effect Chains"))
            {
                ImGui.EndTabItem();
            }
            
            if (ImGui.BeginTabItem("Knobs"))
            {
                ImGui.EndTabItem();
            }
            
            ImGui.EndTabBar();
        }
    }
    
    ImGui.End();
}