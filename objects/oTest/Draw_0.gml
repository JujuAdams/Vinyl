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



UIText(string_concat("\"Test\" mix gain = ", VinylMixGetLocalGain("Test")));



UIButtonInline("\"TestMix\" mix gain -", function()
{
    VinylMixSetLocalGain("Test", VinylMixGetLocalGain("Test") - 0.05);
});
UISpace(20);
UIButton("\"TestMix\" mix gain +", function()
{
    VinylMixSetLocalGain("Test", VinylMixGetLocalGain("Test") + 0.05);
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
    VinylHLTEndLoop(hltVoice);
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



UIButtonInline("Blend linear", function()
{
    VinylSetBlendAnimCurve(blendVoice, undefined);
});
UISpace(20);
UIButton("Blend anim curve", function()
{
    VinylSetBlendFactor(blendVoice, undefined);
});