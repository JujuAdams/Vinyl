shader_set(shdJujuverse);
shader_set_uniform_f(shader_get_uniform(shdJujuverse, "u_fTime"), current_time/11000);
draw_primitive_begin(pr_trianglestrip);
draw_vertex_texture_color(0, 0, 0, 0, c_white, 0.1);
draw_vertex_texture_color(room_width, 0, -room_width/room_height, 0, c_white, 0.1);
draw_vertex_texture_color(0, room_height, 0, 1, c_black, 0.23);
draw_vertex_texture_color(room_width, room_height, -room_width/room_height, 1, c_black, 0.23);
draw_primitive_end();
shader_reset();

draw_set_font(fntText);

UIStart(10, 10, undefined, undefined, true);
UITextInline(string_concat("Vinyl ", __VINYL_VERSION, ", ", __VINYL_DATE, " by Juju Adams\nChicken Nuggets by Wangle Line"));
UINewline();
UINewline();
UITextInline(string_concat("\"Test\" mix gain = ", VinylMixGetGain("Test")));
UINewline();
UIButtonInline("Mix gain -", function()
{
    VinylMixSetGain("Test", VinylMixGetGain("Test") - 0.05);
});
UISpace(20);
UIButtonInline("Mix gain +", function()
{
    VinylMixSetGain("Test", VinylMixGetGain("Test") + 0.05);
});
UISpace(20);
UIButtonInline("Mix slow 0", function()
{
    VinylMixSetGain("Test", 0, 0.05);
});
UISpace(20);
UIButtonInline("Mix slow 1", function()
{
    VinylMixSetGain("Test", 1, 0.05);
});
UINewline();
UINewline();
UIButtonInline("1KHz", function()
{
    VinylPlay(snd1KHz);
});
UISpace(20);
UIButtonInline("Shuffle Bleeps", function()
{
    VinylPlay("Shuffle");
});
UISpace(20);
UIButtonInline("Blast Start", function()
{
    alarm[0] = 4;
});
UISpace(20);
UIButtonInline("Blast End", function()
{
    alarm[0] = -1;
});
UINewline();
UINewline();
UIButtonInline("HLT Test", function()
{
    hltVoice = VinylPlay("HLT");
});
UISpace(20);
UIButtonInline("HLT End Loop", function()
{
    VinylSetLoop(hltVoice, false);
});
UINewline();
UINewline();
UITextInline(string_concat("Blend factor = ", VinylGetBlendFactor(blendVoice)));
UINewline();
UIButtonInline("Blend Test", function()
{
    blendVoice = VinylPlay("Blend");
});
UISpace(20);
UIButtonInline("Factor -", function()
{
    VinylSetBlendFactor(blendVoice, (VinylGetBlendFactor(blendVoice) ?? 0) - 0.05);
});
UISpace(20);
UIButtonInline("Factor +", function()
{
    VinylSetBlendFactor(blendVoice, (VinylGetBlendFactor(blendVoice) ?? 0) + 0.05);
});
UINewline();
UINewline();
UIButtonInline("Set 1KHz gain high", function()
{
    VinylSetupSound(snd1KHz, 1.3, undefined, true);
});
UISpace(20);
UIButtonInline("Set 1KHz gain low", function()
{
    VinylSetupSound(snd1KHz, 0.7, undefined, true);
});
UINewline();
UIButtonInline("Set 1KHz no mix", function()
{
    VinylSetupSound(snd1KHz, undefined, undefined, true, VINYL_NO_MIX);
});
UISpace(20);
UIButtonInline("Set 1KHz \"Test\" mix", function()
{
    VinylSetupSound(snd1KHz, undefined, undefined, true, "Test");
});
UINewline();
UINewline();
UIButtonInline("Duck prio 0", function()
{
    duckPrio0 = VinylPlay(sndSync0, true);
});
UISpace(20);
UIButtonInline("Duck prio 1", function()
{
    duckPrio1 = VinylPlay(sndSync1, true);
});
UISpace(20);
UIButtonInline("Duck prio 2", function()
{
    duckPrio2 = VinylPlay(sndSync2, true);
});
UINewline();
UIButtonInline("Fade out prio 0", function()
{
    VinylFadeOut(duckPrio0);
    duckPrio0 = undefined;
});
UISpace(20);
UIButtonInline("Fade out prio 1", function()
{
    VinylFadeOut(duckPrio1);
    duckPrio1 = undefined;
});
UISpace(20);
UIButtonInline("Fade out prio 2", function()
{
    VinylFadeOut(duckPrio2);
    duckPrio2 = undefined;
});