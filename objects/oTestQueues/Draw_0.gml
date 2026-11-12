draw_set_font(fntText);

UIStart(10, 10, undefined, undefined, true);
UIButton("<-- Back to main menu", function()
{
    instance_destroy();
    instance_create_layer(0, 0, "Instances", oTestMainMenu);
});
UINewline();
UIButtonInline("Play", function()
{
    VinylPlay(queue);
});
UINewline();
UIButtonInline("Stop current", function()
{
    VinylStop(queue);
});
UISpace(20);
UIButtonInline("Fade out current", function()
{
    VinylFadeOut(queue, 1);
});
UISpace(20);
UITextInline($"Behavior = {queue.GetBehavior()}");
UINewline();
UIButtonInline("DONT_LOOP (0)", function()
{
    queue.SetBehavior(VINYL_QUEUE_DONT_LOOP);
});
UISpace(20);
UIButtonInline("LOOP_EACH (1)", function()
{
    queue.SetBehavior(VINYL_QUEUE_LOOP_EACH);
});
UISpace(20);
UIButtonInline("LOOP_ON_LAST (2)", function()
{
    queue.SetBehavior(VINYL_QUEUE_LOOP_ON_LAST);
});
UINewline();
UIButtonInline("Play queue once", function()
{
    VinylSetLoop(queue, false);
});
UISpace(10);
UIButtonInline("Loop queue", function()
{
    VinylSetLoop(queue, true);
});
UINewline();
UINewline();
UIButtonInline("Set 0", function()
{
    VinylFadeOut(queue, 1);
    queue.SetBottom(sndSync0);
});
UISpace(20);
UIButtonInline("Set 1", function()
{
    VinylFadeOut(queue, 1);
    queue.SetBottom(sndSync1);
});
UISpace(20);
UIButtonInline("Set 2", function()
{
    VinylFadeOut(queue, 1);
    queue.SetBottom(sndSync2);
});
UISpace(20);
UIButtonInline("Set 3", function()
{
    VinylFadeOut(queue, 1);
    queue.SetBottom(sndSync3);
});
UISpace(20);
UIButtonInline("Set 1KHz", function()
{
    VinylFadeOut(queue, 1);
    queue.SetBottom(snd1KHz);
});
UINewline();
UIButtonInline("Push 0", function()
{
    queue.PushBottom(sndSync0);
});
UISpace(20);
UIButtonInline("Push 1", function()
{
    queue.PushBottom(sndSync1);
});
UISpace(20);
UIButtonInline("Push 2", function()
{
    queue.PushBottom(sndSync2);
});
UISpace(20);
UIButtonInline("Push 3", function()
{
    queue.PushBottom(sndSync3);
});
UISpace(20);
UIButtonInline("Push 1KHz", function()
{
    queue.PushBottom(snd1KHz);
});
UINewline();
UINewline();
var _asset = VinylGetAsset(queue);
UITextInline(audio_exists(_asset)? audio_get_name(_asset) : "<no sound playing>");
UISpace(20);
UITextInline(VinylGetLoop(queue)? "(looping queue)" : "(playing queue once)");
UINewline();
UIText(json_stringify(queue.GetPlayableArray(), true));