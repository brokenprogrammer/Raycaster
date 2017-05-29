module keyboard;

import Dgame.Window.Window;
import Dgame.Window.Event;
import DgameKeyboard = Dgame.System.Keyboard;

class Keyboard {
    public static handleKeypress(ref Event event, ref Window window) {
        while (window.poll(&event)) {
            switch (event.type) {
                case Event.Type.Quit:
                break;

                case Event.Type.KeyDown:

                    if (event.keyboard.key == DgameKeyboard.Keyboard.Key.Esc) {
                    }

                    if (event.keyboard.key == DgameKeyboard.Keyboard.Key.W) {
                    }

                    if (event.keyboard.key == DgameKeyboard.Keyboard.Key.A) {
                    }

                    if (event.keyboard.key == DgameKeyboard.Keyboard.Key.S) {
                    }

                    if (event.keyboard.key == DgameKeyboard.Keyboard.Key.D) {
                    }

                break;

                default : break;
            }
        }
    }    
}
