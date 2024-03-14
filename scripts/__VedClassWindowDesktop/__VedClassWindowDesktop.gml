// Feather disable all

function __VedClassWindowDesktop() : __VedClassWindow() constructor
{
    static __Update = function()
    {
        __BuildUI();
    }
    
    static __BuildUI = function()
    {
        ImGui.BeginMainMenuBar();
            if (ImGui.BeginMenu("Vinyl"))
            {
                ImGui.TextColored("Juju Adams\n" + __VED_VERSION + "\n" + __VED_DATE, #ff7f00);
            
                ImGui.Separator();
                
            	if (ImGui.MenuItem("GitHub (URL)"))
                {
                    url_open("https://www.github.com/jujuadams/Vinyl");
            	}
    
            	if (ImGui.MenuItem("Documentation (URL)"))
                {
                    url_open("https://www.jujuadams.com/Vinyl");
            	}
    
                ImGui.Separator();
	
            	if (ImGui.MenuItem("Close Editor")) __VedModalOpen(__VedClassModalCloseProject);
                
            	ImGui.EndMenu();
            }
            
            var _i = 0;
            repeat(array_length(_system.__modalsArray))
            {
                _system.__modalsArray[_i].__Update();
                ++_i;
            }
            
            ImGui.PushStyleColor(ImGuiCol.Button, c_white, 0);
            ImGui.SameLine(undefined, 50);

            if (ImGui.Button("Project"))
            {
                __VedWindowOpenSingle(__VedClassWindowProject);
            }
            
            if (ImGui.Button("Config"))
            {
                __VedWindowOpenSingle(__VedClassWindowConfig);
            }
            
            ImGui.SameLine(undefined, 50);

            if (ImGui.Button("Now Playing"))
            {
                __VedWindowOpenSingle(__VedClassWindowNowPlaying);
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