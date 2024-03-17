// Feather disable all

function __VedClassModalNewAssetTag() : __VedClassModal() constructor
{
    __handle = "New Asset Tag";
    
    __assetTagName = "";
    
    static __BuildUI = function()
    {
        if (ImGui.BeginPopupModal(__handle, undefined, ImGuiWindowFlags.NoResize))
        {
            var _libAssetTag = _system.__project.__libAssetTag;
            
            ImGui.Text("Please enter the name of the new asset tag.");
            
            __assetTagName = ImGui.InputTextWithHint("##Asset Tag Name", "e.g. music", __assetTagName);
            var _conflict = _libAssetTag.__Exists(__assetTagName);
            if (_conflict)
            {
                ImGui.SameLine(undefined, 23);
                ImGui.TextColored("Conflict!", #FF5050);
            }
            
            ImGui.Separator();
            
            ImGui.BeginDisabled(_conflict || (string_length(__assetTagName) <= 2));
            if (ImGui.Button("Create"))
            {
                _system.__project.__EnsureAssetTag(__assetTagName);
                __Close();
            }
            ImGui.EndDisabled();
            
            ImGui.SameLine(undefined, 30);
            if (ImGui.Button("Cancel")) __Close();
            
            ImGui.EndPopup();
        }
    }
}