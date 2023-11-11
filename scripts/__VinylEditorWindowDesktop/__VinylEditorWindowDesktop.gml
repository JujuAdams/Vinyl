// Feather disable all

function __VinylEditorWindowDesktop(_stateStruct)
{
    static _editor = __VinylGlobalData().__editor;
    if (not VinylEditorIsShowing()) return;
    
    with(_editor)
    {
        var _exit_modal = false;
        
        ImGui.BeginMainMenuBar();
            if (ImGui.BeginMenu("Vinyl"))
            {
                ImGui.TextColored("ImGUI Test\nJuju Adams\n2023-11-09", #ff7f00);
            
                ImGui.Separator();
            
            	if (ImGui.MenuItem("Global Settings", undefined, undefined, not __VinylEditorWindowGetOpen("__settings")))
                {
                    __VinylEditorWindowSetOpen("__settings", true);
            	}
            
            	if (ImGui.MenuItem("GitHub (URL)"))
                {
                    url_open("https://www.github.com/jujuadams/Vinyl");
            	}
    
            	if (ImGui.MenuItem("Documentation (URL)"))
                {
                    url_open("https://www.jujuadams.com/Vinyl");
            	}
    
                ImGui.Separator();
	
            	if (ImGui.MenuItem("Close Editor"))
                {
            		_exit_modal = true;
            	}
    
            	ImGui.EndMenu();
            }

            if (_exit_modal) ImGui.OpenPopup("Close Editor?");

            ImGui.SetNextWindowPos(window_get_width() / 2, window_get_height () / 2, ImGuiCond.Appearing, 0.5, 0.5);

            if (ImGui.BeginPopupModal("Close Editor?", undefined, ImGuiWindowFlags.NoResize))
            {
            	ImGui.Text("Are you sure you want to close the editor?");
    
            	ImGui.Separator();
    
            	if (ImGui.Button("Get me outta here"))
                {
            	    ImGui.CloseCurrentPopup();
                    instance_destroy();
                    return;
                }
    
            	ImGui.SameLine();
            	if (ImGui.Button("Nope")) ImGui.CloseCurrentPopup();
            	ImGui.EndPopup();	
            }

            ImGui.PushStyleColor(ImGuiCol.Button, c_white, 0);
            ImGui.SameLine(undefined, 40);

            ImGui.BeginDisabled(__VinylEditorWindowGetOpen("__project"));
                if (ImGui.Button("Project")) __VinylEditorWindowSetOpen("__project", true);
            ImGui.EndDisabled();

            if (ImGui.BeginMenu("Config"))
            {
            	if (ImGui.MenuItem("Assets",        undefined, undefined, not __VinylEditorWindowGetOpen("__configAssets"      ))) __VinylEditorWindowSetOpen("__configAssets",       true);
            	if (ImGui.MenuItem("Patterns",      undefined, undefined, not __VinylEditorWindowGetOpen("__configPatterns"    ))) __VinylEditorWindowSetOpen("__configPatterns",     true);
            	if (ImGui.MenuItem("Labels",        undefined, undefined, not __VinylEditorWindowGetOpen("__configLabels"      ))) __VinylEditorWindowSetOpen("__configLabels",       true);
            	if (ImGui.MenuItem("Stacks",        undefined, undefined, not __VinylEditorWindowGetOpen("__configStacks"      ))) __VinylEditorWindowSetOpen("__configStacks",       true);
            	if (ImGui.MenuItem("Knobs",         undefined, undefined, not __VinylEditorWindowGetOpen("__configKnobs"       ))) __VinylEditorWindowSetOpen("__configKnobs",        true);
            	if (ImGui.MenuItem("Effect Chains", undefined, undefined, not __VinylEditorWindowGetOpen("__configEffectChains"))) __VinylEditorWindowSetOpen("__configEffectChains", true);
            	ImGui.EndMenu();
            }

            ImGui.SameLine(undefined, 40);

            ImGui.BeginDisabled(__VinylEditorWindowGetOpen("__nowPlaying"));
                if (ImGui.Button("Now Playing")) __VinylEditorWindowSetOpen("__nowPlaying", true);
            ImGui.EndDisabled();

            ImGui.Button("Take Snapshot!");

            ImGui.BeginDisabled(__VinylEditorWindowGetOpen("__snapshots"));
                if (ImGui.Button("Snapshots")) __VinylEditorWindowSetOpen("__snapshots", true);
            ImGui.EndDisabled();

            ImGui.PopStyleColor();
        ImGui.EndMainMenuBar();
        
        ImGui.SetNextWindowPos(0, room_height - 30);
        ImGui.SetNextWindowSize(room_width, 30, ImGuiCond.Always);
        ImGui.Begin("Status Bar", true, ImGuiWindowFlags.NoTitleBar | ImGuiWindowFlags.NoMove | ImGuiWindowFlags.NoResize);
        ImGui.Text("Waiting" + floor((current_time mod 799) / 200)*".");
        ImGui.End();
    }
}