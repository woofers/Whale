package;

import flixel.FlxGame;
import flixel.FlxG;

/**
    Class to overide FlxGame auto pause visuals
    Author: Jaxson Van Doorn
**/
class MyFlxGame extends FlxGame
{
    override private function onFocus(_):Void
    {
        #if flash
        if (!_lostFocus)
        {
            return;
        }
        #end

        #if desktop

        if (!_onFocusFiredOnce)
        {
            _onFocusFiredOnce = true;
            return;
        }
        #end

        _lostFocus = false;
        FlxG.signals.focusGained.dispatch();

        if (!FlxG.autoPause)
        {
            _state.onFocus();
            return;
        }

        #if !FLX_NO_DEBUG
        debugger.stats.onFocus();
        #end

        stage.frameRate = FlxG.drawFramerate;
        #if !FLX_NO_SOUND_SYSTEM
        FlxG.sound.onFocus();
        #end
        FlxG.inputs.onFocus();
    }

    override private function onFocusLost(_):Void
    {
        #if flash
        if (_lostFocus)
        {
            return;
        }
        #end

        _lostFocus = true;

        FlxG.signals.focusLost.dispatch();

        if (!FlxG.autoPause)
        {
            _state.onFocusLost();
            return;
        }

        #if !FLX_NO_DEBUG
        debugger.stats.onFocusLost();
        #end

        stage.frameRate = focusLostFramerate;
        #if !FLX_NO_SOUND_SYSTEM
        FlxG.sound.onFocusLost();
        #end
        FlxG.inputs.onFocusLost();
    }
}
