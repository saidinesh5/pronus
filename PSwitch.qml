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

PContentRectangle {
    id: binarySwitch

    property bool isOn : false
    property bool isOff : !isOn

    clip: true
    width : 3*PTheme.characterSizeLarge
    height: PTheme.characterSizeLarge

    property var colorSwatch: PTheme.currentColorSwatch
    color: enabled && isOn? colorSwatch.base : PTheme.inactiveBackgroundColor

    PContentRectangle {
        id: knob
        x: binarySwitch.isOn*parent.width/2
        width: parent.width/2
        height: parent.height

        MouseArea {
            id: mouseArea
            anchors.fill: parent

            drag.target: knob
            drag.axis: Drag.XAxis
            drag.minimumX: 0
            drag.maximumX: knob.width

            drag.onActiveChanged: {
                if(!drag.active){
                    binarySwitch.isOn = knob.x/binarySwitch.width > 0.25
                    binarySwitch.isOn = !binarySwitch.isOn
                    binarySwitch.isOn = !binarySwitch.isOn
                }
            }
            onClicked: binarySwitch.isOn = !binarySwitch.isOn
        }
    }

    Behavior on color { ColorAnimation{ duration: PTheme.animationDuration } }
}

