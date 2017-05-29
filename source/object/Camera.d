module camera;

import vector2d;

class Camera {
    // Position vector
    auto pos = Vector2D(3, 7);

    // Direction vector.
    auto dir = Vector2D(1, 0);

    // 2D Raycaster camera plane.
    auto plane = Vector2D(0, 0.5);
}
