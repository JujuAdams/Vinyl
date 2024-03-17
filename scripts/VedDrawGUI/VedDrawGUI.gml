// Feather disable all

function VedDrawGUI()
{
    static _system = __VedSystem();
    if (_system.__showing) ImGui.__Render();
}