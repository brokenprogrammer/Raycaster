module keyboard;

import Dgame.Window.Window;
import Dgame.Window.Event;
import Dgame.System.Keyboard;

class keyboard
{
    public static handleKeypress(ref Event event, ref Window window)
    {
        while (window.poll(&event)) {
            switch (event.type) {
                case Event.Type.Quit:
                break;

                case Event.Type.KeyDown:

                    if (event.keyboard.key == Keyboard.Key.Esc) {
                    }

                    if (event.keyboard.key == Keyboard.Key.W) {
                    }

                    if (event.keyboard.key == Keyboard.Key.A) {
                    }

                    if (event.keyboard.key == Keyboard.Key.S) {
                    }

                    if (event.keyboard.key == Keyboard.Key.D) {
                    }

                break;

                default : break;
            }
        }
    }    
}