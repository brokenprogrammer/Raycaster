module keyboard;

import std.conv;

import Dgame.Window.Window;
import Dgame.Window.Event;
import DgameKeyboard = Dgame.System.Keyboard;

import camera;
import worldmap;

class Keyboard {

    //speed modifiers
    private static double moveSpeed = 0.03; //the constant value is in squares/second
    private static double rotSpeed = 0.02; //the constant value is in radians/second

    public static handleKeypress(ref Event event, ref Camera cam, ref bool running) {
        if (event.type == Event.Type.Quit) {
            running = false;
        }

        if (event.type == Event.Type.KeyDown) {

            if (event.keyboard.key == DgameKeyboard.Keyboard.Key.Esc) {
                running = false;
            }

            if (event.keyboard.key == DgameKeyboard.Keyboard.Key.W) {
                if(!WorldMap.isWall(to!int(cam.pos.x + cam.dir.x * this.moveSpeed), 
                            to!int(cam.pos.y))) {
                    cam.pos.x += cam.dir.x * this.moveSpeed;
                }
                if (!WorldMap.isWall(to!int(cam.pos.x), 
                            to!int(cam.pos.y + cam.dir.y * this.moveSpeed))) {
                    cam.pos.y += cam.dir.y * this.moveSpeed;
                }
            }

            if (event.keyboard.key == DgameKeyboard.Keyboard.Key.A) {
                cam.dir.rotate(-this.rotSpeed);
                cam.plane.rotate(-this.rotSpeed);
            }

            if (event.keyboard.key == DgameKeyboard.Keyboard.Key.S) {
                if (!WorldMap.isWall(to!int(cam.pos.x - cam.dir.x * this.moveSpeed),
                            to!int(cam.pos.y))) {
                    cam.pos.x -= cam.dir.x * this.moveSpeed;
                }
                if (!WorldMap.isWall(to!int(cam.pos.x),
                            to!int(cam.pos.y - cam.dir.y * this.moveSpeed))) {
                    cam.pos.y -= cam.dir.y * this.moveSpeed;
                }
            }

            if (event.keyboard.key == DgameKeyboard.Keyboard.Key.D) {
               cam.dir.rotate(this.rotSpeed);
               cam.plane.rotate(this.rotSpeed);
            }
        }
    }    
}
