// Feather disable all

function __VinylEditorWindowNowPlaying()
{
    static _editor = __VinylGlobalData().__editor;
    if (not VinylEditorIsShowing()) return;
    
    ImGui.SetNextWindowSize(room_width/2, room_height/2, ImGuiCond.Once);
    ImGui.SetNextWindowPos(room_width/4, room_height/4, ImGuiCond.Once);
	
    var ret = ImGui.Begin("Now Playing", __VinylEditorWindowGetOpen("__nowPlaying"), undefined, ImGuiReturnMask.Both);
    __VinylEditorWindowSetOpen("__nowPlaying", (ret & ImGuiReturnMask.Pointer));
    
    ImGui.End();
}