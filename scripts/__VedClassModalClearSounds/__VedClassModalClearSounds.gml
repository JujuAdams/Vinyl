// Feather disable all

function __VedClassModalClearSounds() : __VedClassModal() constructor
{
    __handle = "Clear Sounds?";
    __multiselector = undefined;
    __dictionary = undefined;
    
    static __BuildUI = function()
    {
        if (ImGui.BeginPopupModal(__handle, undefined, ImGuiWindowFlags.NoResize))
        {
            ImGui.Text("Are you sure you want to clear all sounds for this pattern?");
            
            ImGui.Separator();
            
            if (ImGui.Button("Clear"))
            {
            	__Close();
                
                if ((__multiselector != undefined) && (__dictionary != undefined))
                {
                    __multiselector.__ForEachSelected(__dictionary, function(_name, _struct, _metadata)
                    {
                        _struct.__ClearSoundArray();
                    });
                }
                
                return;
            }
            
            ImGui.SameLine();
            if (ImGui.Button("Keep all sounds")) __Close();
            
            ImGui.EndPopup();
        }
    }
}