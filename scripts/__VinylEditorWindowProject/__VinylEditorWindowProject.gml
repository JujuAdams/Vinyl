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
		var _width = ImGui.GetContentRegionAvailX();
		
		ImGui.BeginChild("Paths", _width, 150, true);
        ImGui.Text("Paths");
        ImGui.DrawListAddLine(ImGui.GetWindowDrawList(), ImGui.GetItemRectMinX(), ImGui.GetItemRectMaxY(), ImGui.GetItemRectMaxX(), ImGui.GetItemRectMaxY(), c_white);
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
        ImGui.DrawListAddLine(ImGui.GetWindowDrawList(), ImGui.GetItemRectMinX(), ImGui.GetItemRectMaxY(), ImGui.GetItemRectMaxX(), ImGui.GetItemRectMaxY(), c_white);
        
        _document.__SettingSet("autogenerateMacros", ImGui.Checkbox("Autogenerate Macros", _document.__SettingGet("autogenerateMacros")));
        _document.__SettingSet("macroScriptName", ImGui.InputText("Macro Script Name", _document.__SettingGet("macroScriptName")));
        ImGui.Button("Generate Macros Now!");
        
		ImGui.EndChild();
        
        
        
		ImGui.BeginChild("Document", _width, 60, true);
        
        ImGui.Text("Document");
        ImGui.DrawListAddLine(ImGui.GetWindowDrawList(), ImGui.GetItemRectMinX(), ImGui.GetItemRectMaxY(), ImGui.GetItemRectMaxX(), ImGui.GetItemRectMaxY(), c_white);
        
        ImGui.Button("Clean Up Unused Properties");
        
		ImGui.EndChild();
    }
    
    ImGui.End();
}