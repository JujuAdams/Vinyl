draw_set_font(fntText);

UIStart(10, 10, undefined, undefined, true);
UIButtonInline("General Test", function()
{
    instance_destroy();
    instance_create_layer(0, 0, "Instances", oTestGeneral);
});
UINewline();
UINewline();
UIButton("Test 1", function()
{
    VinylPlayAt(sndBleep0, 0, 0, 0,   0, 100);
});
UIButton("Test Left", function()
{
    VinylPlayAt(sndBleep0, -75, 0, 0,   50, 150);
});
UIButton("Test Right", function()
{
    VinylPlayAt(sndBleep0, 75, 0, 0,   50, 150);
});