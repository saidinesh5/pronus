/**
 * Copyright (c) 2015 Dinesh Manajpet
 * Permission is hereby granted, free of charge, to any person obtaining a copy
 * of this software and associated documentation files (the "Software"), to deal
 * in the Software without restriction, including without limitation the rights
 * to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 * copies of the Software, and to permit persons to whom the Software is
 * furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in
 * all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 **/

import QtQuick 2.0
import '.'

Item {
    id: knob
    property real minX: 0
    property real minY: 0
    property real maxX: parent.width
    property real maxY: parent.height

    property alias pressed: mouseArea.pressed

    property var colorSwatch: PTheme.currentColorSwatch

    signal released()
    signal positionChanged(point position)

    PContentRectangle {
        id: content
        x: -width/2
        y: -height/2

        color: Qt.rgba(255, 255, 255, 0.5)
        border.color: knob.pressed? colorSwatch.base : colorSwatch.dark

        width: PTheme.characterSizeNormal*2
        height: width
        radius: height/2

        MouseArea {
            id: mouseArea
            anchors.fill: parent
            drag.target: knob

            drag.minimumX: knob.minX
            drag.maximumX: knob.maxX
            drag.minimumY: knob.minY
            drag.maximumY: knob.maxY

            onReleased: knob.released()
            onPositionChanged: knob.positionChanged(Qt.point(knob.x, knob.y))
        }
    }
}
