// Feather disable all

function __VedClassDesktop() : __VedClassWindow() constructor
{
    static __Build = function()
    {
        var _exit_modal = false;
        
        ImGui.BeginMainMenuBar();
            if (ImGui.BeginMenu("Vinyl"))
            {
                ImGui.TextColored("ImGUI Test\nJuju Adams\n2023-11-09", #ff7f00);
            
                ImGui.Separator();
            
            	//if (ImGui.MenuItem("Global Settings", undefined, undefined, not __VedWindowGetOpen("__settings")))
                //{
                //    __VedWindowSetOpen("__settings", true);
            	//}
            
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
                    VedClose();
                    return;
                }
    
            	ImGui.SameLine();
            	if (ImGui.Button("Nope")) ImGui.CloseCurrentPopup();
            	ImGui.EndPopup();	
            }

            ImGui.PushStyleColor(ImGuiCol.Button, c_white, 0);
            ImGui.SameLine(undefined, 50);

            if (ImGui.Button("Project"))
            {
                if (__VedWindowGetOpen("__project"))
                {
                    ImGui.SetWindowFocus("Project");
                }
                else
                {
                    __VedWindowSetOpen("__project", true);
                }
            }
            
            if (ImGui.Button("Config"))
            {
                if (__VedWindowGetOpen("__config"))
                {
                    ImGui.SetWindowFocus("Config");
                }
                else
                {
                    __VedWindowSetOpen("__config", true);
                }
            }
            
            if (ImGui.Button("Sound Test"))
            {
                if (__VedWindowGetOpen("__soundTest"))
                {
                    ImGui.SetWindowFocus("Sound Test");
                }
                else
                {
                    __VedWindowSetOpen("__soundTest", true);
                }
            }
            
            ImGui.SameLine(undefined, 50);

            if (ImGui.Button("Now Playing"))
            {
                if (__VedWindowGetOpen("__nowPlaying"))
                {
                    ImGui.SetWindowFocus("Now Playing");
                }
                else
                {
                    __VedWindowSetOpen("__nowPlaying", true);
                }
            }
            
            if (ImGui.Button("Take Snapshot!"))
            {
                __VedSnapshot();
            }

            if (ImGui.Button("Snapshots"))
            {
                if (__VedWindowGetOpen("__snapshots"))
                {
                    ImGui.SetWindowFocus("Snapshots");
                }
                else
                {
                    __VedWindowSetOpen("__snapshots", true);
                }
            }
            
            ImGui.PopStyleColor();
        ImGui.EndMainMenuBar();
        
        ImGui.SetNextWindowPos(0, room_height - 30);
        ImGui.SetNextWindowSize(room_width, 30, ImGuiCond.Always);
        ImGui.Begin("Status Bar", true, ImGuiWindowFlags.NoTitleBar | ImGuiWindowFlags.NoMove | ImGuiWindowFlags.NoResize);
        ImGui.Text(floor((current_time mod 799) / 200)*".");
        ImGui.End();
    }
}