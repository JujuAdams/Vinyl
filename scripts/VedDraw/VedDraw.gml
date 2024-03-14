// Feather disable all

function VedDraw()
{
    static _system = __VedSystem();
    if (_system.__showing) ImGui.__Render();
}