// Feather disable all

function __VinylEditorWindowFilter(_stateStruct)
{
    static _editor = __VinylGlobalData().__editor;
    if (not VinylEditorIsShowing()) return;
    
    ImGui.SetNextWindowSize(0.4*room_width, 0.27*room_height, ImGuiCond.Once);
    ImGui.SetNextWindowPos(0.25*room_width, 0.25*room_height, ImGuiCond.Once);
	
    var ret = ImGui.Begin("Filter", __VinylEditorWindowGetOpen("__filter"), undefined, ImGuiReturnMask.Both);
    __VinylEditorWindowSetOpen("__filter", (ret & ImGuiReturnMask.Pointer));
    
    if (ret & ImGuiReturnMask.Return)
    {
        if (ImGui.BeginTable("Table", 3))
        {
            ImGui.TableSetupColumn("Name",   ImGuiTableColumnFlags.WidthFixed, 120);
            ImGui.TableSetupColumn("Active", ImGuiTableColumnFlags.WidthFixed, 30);
            ImGui.TableSetupColumn("Value",  ImGuiTableColumnFlags.WidthStretch, 1);
            
            ImGui.TableNextRow();
            ImGui.TableSetColumnIndex(0);
            ImGui.Text("Match Name");
            ImGui.TableSetColumnIndex(1);
            ImGui.Checkbox("##", false);
            ImGui.TableSetColumnIndex(2);
            ImGui.InputTextWithHint("##", "e.g. sndBleep*", "");
            
            ImGui.TableNextRow();
            ImGui.TableSetColumnIndex(0);
            ImGui.Text("Length Between");
            ImGui.TableSetColumnIndex(1);
            ImGui.Checkbox("##", false);
            ImGui.TableSetColumnIndex(2);
            ImGui.InputFloat2("seconds##", [0, 5]);
            
            ImGui.TableNextRow();
            ImGui.TableSetColumnIndex(0);
            ImGui.Text("Audio Group");
            ImGui.TableSetColumnIndex(1);
            ImGui.Checkbox("##", false);
            ImGui.TableSetColumnIndex(2);
            if (ImGui.BeginCombo("##Audio Group", "", ImGuiComboFlags.None))
            {
                var _audioGroupArray = __VinylDocument().__ProjectGetAudioGroupArray();
                var _i = 0;
                repeat(array_length(_audioGroupArray))
                {
                    var _audioGroup = _audioGroupArray[_i];
                    if (ImGui.Checkbox(_audioGroup, false))
                    {
                        
                    }
                    
                    ++_i;
                }
                
                ImGui.EndCombo();
            }
            
            ImGui.TableNextRow();
            ImGui.TableSetColumnIndex(0);
            ImGui.Text("Attribute");
            ImGui.TableSetColumnIndex(1);
            ImGui.Checkbox("##", false);
            ImGui.TableSetColumnIndex(2);
            ImGui.Checkbox("WAV##", false);
            ImGui.Checkbox("OGG##", false);
            ImGui.Checkbox("OGG 2##", false);
            ImGui.Checkbox("OGG 3##", false);
            
            ImGui.EndTable();
        }
    }
    
    ImGui.End();
}