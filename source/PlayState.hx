package;

import flixel.FlxG;
import flixel.group.FlxGroup;
import flixel.group.FlxSpriteGroup;
import flixel.util.FlxCollision;
import flixel.FlxCamera;
import flixel.FlxCamera.FlxCameraFollowStyle;
import flixel.FlxSprite;
import flixel.FlxState;
import flixel.ui.FlxButton;
import flixel.text.FlxText;
import flixel.math.FlxMath;
import flixel.math.FlxRandom;
import flixel.group.FlxSpriteGroup;

import flixel.text.FlxBitmapText;
import flixel.graphics.frames.FlxBitmapFont;
import flixel.text.FlxText;
import openfl.Assets;
import flixel.util.FlxColor;
import flixel.FlxSubState;
import flixel.ui.FlxButton;

/**
    State when the user is playing the game
    Author: Jaxson Van Doorn
**/
class PlayState extends FlxState
{

    private var player:Player;
    private var level:Level;
    private var enemies:FlxTypedSpriteGroup<Enemy>;

    private var scoreHeader:FlxSprite;
    private var scoreValue:Int;
    private var scoreField:FlxBitmapText;
    private var pauseButton:FlxButton;
    private var pauseMenu:PauseMenu;
    private var fontStyle:FlxBitmapFont;

    private static inline var SCREEN_WIDTH = 1080;
    private static inline var SCREEN_HEIGHT = 11520;

    override public function create():Void
    {
        super.create();

        FlxG.mouse.useSystemCursor = true;

        createBackground();
        createText();

        // Group
        enemies = new FlxTypedSpriteGroup<Enemy>();
        add(enemies);

        // Level
        level = new Level(enemies);

        // Player
        player = new Player(level, enemies);
        level.setPlayer(player);
        add(player);

        // Create Level
        level.generate();

        // Create UI
        createPauseMenu();
        createPauseGameButton();

        // Camera
        FlxG.camera.setScrollBoundsRect(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT, false);
        FlxG.camera.follow(player, FlxCameraFollowStyle.PLATFORMER);
        FlxG.camera.antialiasing = true;
    }

    override public function destroy():Void
    {
        enemies = null;
        level.kill();
        player.kill();
        scoreHeader.kill();
        scoreField.destroy();
        pauseButton.kill();
        pauseMenu.destroy();
        fontStyle.destroy();

        level = null;
        player = null;
        scoreHeader = null;
        scoreField = null;
        pauseButton = null;
        pauseMenu = null;
        fontStyle = null;

        super.destroy();
    }

    override public function update(dt:Float):Void
    {
        super.update(dt);
        setScore(player.score());
    }

    public function intToString(i:Int):String
    {
        var strbuf:StringBuf = new StringBuf();
        strbuf.add(i);
        return strbuf.toString();
    }

    private function createText():Void
    {
        // Score Header
        scoreHeader = new FlxSprite(40, 40, "assets/images/ui/pause/score.png");
        scoreHeader.scrollFactor.x = scoreHeader.scrollFactor.y = 0;
        scoreHeader.origin.x = scoreHeader.origin.y = 0;
        scoreHeader.scale.x = scoreHeader.scale.y = 0.2;
        add(scoreHeader);

        // Font Style
        fontStyle = FlxBitmapFont.fromAngelCode(
                Assets.getBitmapData(
                     "assets/font/font.png"),
                     Xml.parse(Assets.getText("assets/font/font.fnt")));

        // Score
        scoreField = new FlxBitmapText(fontStyle);
        scoreField.scrollFactor.x = scoreField.scrollFactor.y = 0;
        scoreField.text = "0";
        scoreField.useTextColor = false;
        scoreField.color = 0xffEE4D4D;
        scoreField.x = 45;
        scoreField.y = 80;

        scoreField.alignment = FlxTextAlign.CENTER;
        scoreField.multiLine = true;
        scoreField.wordWrap = false;
        add(scoreField);
    }

    private function createBackground():Void
    {
        // Background
        add(new FlxSprite(0, 0, "assets/images/background/0.png"));
        add(new FlxSprite(0, 2048, "assets/images/background/1.png"));
        add(new FlxSprite(0, 4096, "assets/images/background/2.png"));
        add(new FlxSprite(0, 6144, "assets/images/background/3.png"));
        add(new FlxSprite(0, 8192, "assets/images/background/4.png"));
        add(new FlxSprite(0, 10240, "assets/images/background/5.png"));
    }

    public function createPauseMenu():Void
    {
        pauseMenu = new PauseMenu(this, fontStyle);
    }

    private function createPauseGameButton():Void
    {
        pauseButton = new FlxButton(896, 20, "", pauseGame);
        pauseButton.loadGraphic("assets/images/ui/pause/pause.png");
        pauseButton.scrollFactor.x = pauseButton.scrollFactor.y = 0;
        add(pauseButton);
    }

    private function hideMenu():Void
    {
        pauseButton.visible = false;
        scoreHeader.visible = false;
        scoreField.visible = false;
    }

    public function showMenu():Void
    {
        pauseButton.visible = true;
        scoreHeader.visible = true;
        scoreField.visible = true;
    }

    /**
        Function called by the pause button pause the game
    **/
    private function pauseGame():Void
    {
        // Hide Other UI Elements
        hideMenu();
        openSubState(pauseMenu);
    }

    private function setScore(score:Int):Void
    {
        scoreField.text = intToString(score);
    }

    public function score():String
    {
        return scoreField.text;
    }
}
