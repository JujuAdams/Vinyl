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
UIText(string_concat("Vinyl ", __VINYL_VERSION, ", ", __VINYL_DATE, " by Juju Adams\nChicken Nuggets by Wangle Line"));

UINewline();
UIText(string_concat("\"Test\" mix gain = ", VinylMixGetGain("Test")));



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
UIButton("Mix slow 1", function()
{
    VinylMixSetGain("Test", 1, 0.05);
});



UINewline();
UIButtonInline("1KHz", function()
{
    VinylPlay(snd1KHz);
});
UISpace(20);
UIButton("Shuffle Bleeps", function()
{
    VinylPlay("Shuffle");
});



UINewline();
UIButtonInline("HLT Test", function()
{
    hltVoice = VinylPlay("HLT");
});
UISpace(20);
UIButton("HLT End Loop", function()
{
    VinylSetLoop(hltVoice, false);
});



UINewline();
UIText(string_concat("Blend factor = ", VinylGetBlendFactor(blendVoice)));
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
UIButton("Factor +", function()
{
    VinylSetBlendFactor(blendVoice, (VinylGetBlendFactor(blendVoice) ?? 0) + 0.05);
});



UINewline();
UIButtonInline("Set 1KHz gain high", function()
{
    VinylSetupSound(snd1KHz, 1.3);
});
UISpace(20);
UIButton("Set 1KHz gain low", function()
{
    VinylSetupSound(snd1KHz, 0.7);
});

UIButtonInline("Set 1KHz no mix", function()
{
    VinylSetupSound(snd1KHz);
});
UISpace(20);
UIButton("Set 1KHz \"Test\" mix", function()
{
    VinylSetupSound(snd1KHz, undefined, undefined, undefined, "Test");
});