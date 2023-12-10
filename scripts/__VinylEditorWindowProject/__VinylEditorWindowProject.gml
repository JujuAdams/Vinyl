// Feather disable all

function __VinylEditorWindowProject()
{
    static _editor = __VinylGlobalData().__editor;
    if (not VinylEditorIsShowing()) return;
    
    var _document = __VinylDocument();
    
    ImGui.SetNextWindowSize(room_width/2, room_height/2, ImGuiCond.Once);
    ImGui.SetNextWindowPos(room_width/4, room_height/4, ImGuiCond.Once);
	
    var ret = ImGui.Begin("Project", __VinylEditorWindowGetOpen("__project"), undefined, ImGuiReturnMask.Both);
    __VinylEditorWindowSetOpen("__project", (ret & ImGuiReturnMask.Pointer));
    
    if (ret & ImGuiReturnMask.Return)
    {
		if (ImGui.BeginTabBar("Tab Bar"))
        {
            if (ImGui.BeginTabItem("General"))
            {
        		var _width = ImGui.GetContentRegionAvailX();
		
        		ImGui.BeginChild("Paths", _width, 150, true);
                ImGui.Text("Paths");
                __VINYL_UNDERLINE_PREV_TEXT
                ImGui.Text("GameMaker Project:");
                ImGui.SetCursorPosX(50);
                ImGui.TextUnformatted(GM_project_filename);
        
                ImGui.Text("Vinyl Document:");
                ImGui.SetCursorPosX(50);
                ImGui.TextUnformatted(_document.__GetPath());
        
                ImGui.Text("Macro Script Path:");
                ImGui.SetCursorPosX(50);
                ImGui.TextWrapped(_document.__GetMacroScriptPath());
        		ImGui.EndChild();
        
        
        
        		ImGui.BeginChild("Macro Generation", _width, 100, true);
        
                ImGui.Text("Macro Generation");
                __VINYL_UNDERLINE_PREV_TEXT
        
                _document.__SettingSet("autogenerateMacros", ImGui.Checkbox("Autogenerate Macros", _document.__SettingGet("autogenerateMacros")));
                _document.__SettingSet("macroScriptName", ImGui.InputText("Macro Script Name", _document.__SettingGet("macroScriptName")));
                ImGui.Button("Generate Macros Now!");
        
        		ImGui.EndChild();
        
        
        
        		ImGui.BeginChild("Document", _width, 60, true);
        
                ImGui.Text("Document");
                __VINYL_UNDERLINE_PREV_TEXT
        
                ImGui.Button("Clean Up Unused Properties");
        
        		ImGui.EndChild();
                
                ImGui.EndTabItem();
            }
            
            if (ImGui.BeginTabItem("Audio Groups"))
            {
                ImGui.TextWrapped("Below are the audio groups discovered in the project. This information is provided for debugging purposes.", ImGui.GetContentRegionAvailX());
                
                ImGui.NewLine();
                
                ImGui.BeginChild("Project Audio Group View", 0.3*ImGui.GetContentRegionAvailX(), undefined, true);
                
                var _tabData  = _editor.__windowStates.__project.__tabAudioGroups;
                var _selected = _tabData.__selected;
                
                var _array = _document.__GetProjectAudioGroupArray();
                var _i = 0;
                repeat(array_length(_array))
                {
                    var _audioGroup = _array[_i];
                    if (ImGui.Selectable(_audioGroup + "##Project Audio Group Selectable", (_selected == _audioGroup)))
                    {
                        _tabData.__selected = _audioGroup;
                    }
                    
                    ++_i;
                }
                
                ImGui.EndChild();
                
                ImGui.SameLine();
                
                ImGui.BeginChild("Project Audio Group Detail", ImGui.GetContentRegionAvailX(), undefined, true);
                
                if (is_string(_selected))
                {
                    var _audioGroupDict = _document.__GetProjectAudioGroupDict();
                    var _array = _audioGroupDict[$ _selected];
                    
                    if ((not is_array(_array)) || (array_length(_array) <= 0))
                    {
                        ImGui.Text("No sounds in audio group \"" + _selected + "\"");
                    }
                    else
                    {
                        var _i = 0;
                        repeat(array_length(_array))
                        {
                            ImGui.Text(_array[_i]);
                            ++_i;
                        }
                    }
                }
                
                ImGui.EndChild();
                
                ImGui.EndTabItem();
            }
            
            if (ImGui.BeginTabItem("Asset Tags"))
            {
                ImGui.TextWrapped("Below are the asset tags assigned to sounds discovered in the project. Asset tags not assigned to sounds will not be displayed. This information is provided for debugging purposes.", ImGui.GetContentRegionAvailX());
                
                ImGui.NewLine();
                
                ImGui.BeginChild("Project Audio Group View", 0.3*ImGui.GetContentRegionAvailX(), undefined, true);
                
                var _tabData  = _editor.__windowStates.__project.__tabAssetTags;
                var _selected = _tabData.__selected;
                
                var _document = __VinylDocument();
                var _array = _document.__GetProjectAssetTagArray();
                
                var _i = 0;
                repeat(array_length(_array))
                {
                    var _assetTag = _array[_i];
                    if (ImGui.Selectable(_assetTag + "##Project Asset Tag Selectable", (_selected == _assetTag)))
                    {
                        _tabData.__selected = _assetTag;
                    }
                    
                    ++_i;
                }
                
                ImGui.EndChild();
                
                ImGui.SameLine();
                
                ImGui.BeginChild("Project Asset Tag Detail", ImGui.GetContentRegionAvailX(), undefined, true);
                
                if (is_string(_selected))
                {
                    var _assetTagDict = _document.__GetProjectAssetTagDict();
                    var _array = _assetTagDict[$ _selected];
                    
                    if ((not is_array(_array)) || (array_length(_array) <= 0))
                    {
                        ImGui.Text("No sounds with asset tag \"" + _selected + "\"");
                    }
                    else
                    {
                        var _i = 0;
                        repeat(array_length(_array))
                        {
                            ImGui.Text(_array[_i]);
                            ++_i;
                        }
                    }
                }
                
                ImGui.EndChild();
                
                ImGui.EndTabItem();
            }
            
            ImGui.EndTabBar();
        }
    }
    
    ImGui.End();
}