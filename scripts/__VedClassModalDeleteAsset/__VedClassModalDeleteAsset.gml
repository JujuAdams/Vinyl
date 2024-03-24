// Feather disable all

function __VedClassModalDeleteAsset() : __VedClassModal() constructor
{
    __handle = "Delete Asset?";
    __assetName = "<unknown asset>";
    __function = undefined;
    
    static __BuildUI = function()
    {
        if (ImGui.BeginPopupModal(__handle, undefined, ImGuiWindowFlags.NoResize))
        {
            ImGui.Text($"Are you sure you want to delete {__assetName}?");
            
            ImGui.Separator();
            
            if (ImGui.Button("Delete"))
            {
            	__Close();
                if (__function != undefined) __function();
                return;
            }
            
            ImGui.SameLine();
            if (ImGui.Button("Keep")) __Close();
            
            ImGui.EndPopup();
        }
    }
}