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
    id: checkBox

    width: 1.5*PTheme.characterSizeNormal
    height: width

    property bool isOn: false

    property var colorSwatch: PTheme.currentColorSwatch

    color: enabled? (isOn? colorSwatch.base : PTheme.backgroundColor) :
                    PTheme.inactiveBackgroundColor
    border.color: PTheme.borderColor

    PLabel {
        id: tickMark
        anchors.centerIn: parent
        label: isOn? FontAwesome.icon.check : '' //'\u2705' looks better
        color: enabled? PTheme.invertedTextColor : PTheme.invertedInactiveTextColor
        font.pointSize: PTheme.fontSizeLarge
        font.bold: true
        font.family: FontAwesome.fontName
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onClicked: isOn = !isOn
    }
}
