draw_set_font(fntText);

UIStart(10, 10, undefined, undefined, true);
UIButtonNewline("<-- Back to main menu", function()
{
    instance_destroy();
    instance_create_layer(0, 0, "Instances", oTestMainMenu);
});
UINewline();
UIButton("Play", function()
{
    VinylPlay(queue);
});
UINewline();
UIButton("Stop current", function()
{
    VinylStop(queue);
});
UISpace(20);
UIButton("Fade out current", function()
{
    VinylFadeOut(queue, 1);
});
UISpace(20);
UIText($"Behavior = {queue.GetBehavior()}");
UINewline();
UIButton("DONT_LOOP (0)", function()
{
    queue.SetBehavior(VINYL_QUEUE_DONT_LOOP);
});
UISpace(20);
UIButton("LOOP_EACH (1)", function()
{
    queue.SetBehavior(VINYL_QUEUE_LOOP_EACH);
});
UISpace(20);
UIButton("LOOP_ON_LAST (2)", function()
{
    queue.SetBehavior(VINYL_QUEUE_LOOP_ON_LAST);
});
UINewline();
UIButton("Play queue once", function()
{
    VinylSetLoop(queue, false);
});
UISpace(10);
UIButton("Loop queue", function()
{
    VinylSetLoop(queue, true);
});
UINewline();
UINewline();
UIButton("Set 0", function()
{
    VinylFadeOut(queue, 1);
    queue.SetBottom(sndSync0);
});
UISpace(20);
UIButton("Set 1", function()
{
    VinylFadeOut(queue, 1);
    queue.SetBottom(sndSync1);
});
UISpace(20);
UIButton("Set 2", function()
{
    VinylFadeOut(queue, 1);
    queue.SetBottom(sndSync2);
});
UISpace(20);
UIButton("Set 3", function()
{
    VinylFadeOut(queue, 1);
    queue.SetBottom(sndSync3);
});
UISpace(20);
UIButton("Set 1KHz", function()
{
    VinylFadeOut(queue, 1);
    queue.SetBottom(snd1KHz);
});
UINewline();
UIButton("Push 0", function()
{
    queue.PushBottom(sndSync0);
});
UISpace(20);
UIButton("Push 1", function()
{
    queue.PushBottom(sndSync1);
});
UISpace(20);
UIButton("Push 2", function()
{
    queue.PushBottom(sndSync2);
});
UISpace(20);
UIButton("Push 3", function()
{
    queue.PushBottom(sndSync3);
});
UISpace(20);
UIButton("Push 1KHz", function()
{
    queue.PushBottom(snd1KHz);
});
UINewline();
UINewline();
var _asset = VinylGetAsset(queue);
UIText(audio_exists(_asset)? audio_get_name(_asset) : "<no sound playing>");
UISpace(20);
UIText(VinylGetLoop(queue)? "(looping queue)" : "(playing queue once)");
UINewline();
UITextNewline(json_stringify(queue.GetPlayableArray(), true));