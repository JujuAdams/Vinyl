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



UIText(string_concat("\"test\" mix gain = ", VinylMixGetLocalGain("test")));



UIButtonInline("\"test\" mix gain +", function()
{
    VinylMixSetLocalGain("test", VinylMixGetLocalGain("test") - 0.05);
});
UISpace(20);
UIButton("\"test\" mix gain -", function()
{
    VinylMixSetLocalGain("test", VinylMixGetLocalGain("test") + 0.05);
});



UINewline();
UIButtonInline("1KHz", function()
{
    VinylPlay(snd1KHz);
});
UISpace(20);
UIButton("Shuffle Bleeps", function()
{
    VinylPlay("shuffle");
});



UINewline();
UIButtonInline("HLT Test", function()
{
    hltVoice = VinylPlay("hlt");
});
UISpace(20);
UIButton("HLT End Loop", function()
{
    VinylHLTEndLoop(hltVoice);
});



UINewline();
UIText(string_concat("Blend factor = ", VinylGetBlend(blendVoice)));
UIButtonInline("Blend Test", function()
{
    blendVoice = VinylPlay("blend");
});
UISpace(20);
UIButtonInline("Factor +", function()
{
    VinylSetBlend(blendVoice, (VinylGetBlend(blendVoice) ?? 0) + 0.05);
});
UISpace(20);
UIButton("Factor -", function()
{
    VinylSetBlend(blendVoice, (VinylGetBlend(blendVoice) ?? 0) - 0.05);
});



UIButtonInline("Blend linear", function()
{
    //VinylSetBlendAnimCurve(blendVoice, VinylGetBlend(blendVoice), undefined);
});
UISpace(20);
UIButton("Blend anim curve", function()
{
    //VinylSetBlend(blendVoice, (VinylGetBlend(blendVoice) ?? 0) - 0.05);
});