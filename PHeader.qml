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

Rectangle {
    id:header

    property alias leftButtonVisible: leftButton.visible
    property alias leftButtonIcon: leftButton.icon
    property alias leftButtonLabel: leftButton.label
    
    property alias rightButtonVisible: rightButton.visible
    property alias rightButtonIcon: rightButton.icon
    property alias rightButtonLabel: rightButton.label

    property alias titleIcon: titleButton.icon
    property alias titleIconPath: titleButton.iconPath
    property alias title: titleButton.label

    height: 2*PTheme.characterHeightLarge
    color: PTheme.invertedBackgroundColor

    signal titleClicked()
    signal titleDoubleClicked()
    signal titleLongClicked()
    
    signal leftButtonClicked()
    signal rightButtonClicked()
    
    PPushButton {
        id: leftButton

        anchors.verticalCenter: parent.verticalCenter
        anchors.left: parent.left
        anchors.leftMargin: PTheme.marginSizeNormal

        iconPointSize: PTheme.iconSizeSmall
        onClicked: header.leftButtonClicked()
    }
    

    PPushButton {
        id: titleButton
        anchors.left: leftButton.right
        anchors.right: rightButton.left
        anchors.verticalCenter: parent.verticalCenter
        anchors.margins: PTheme.marginSizeNormal

        labelPointSize: PTheme.fontSizeLarge
        labelBoldText: true
        contentColor: PTheme.invertedTextColor
        color: 'transparent'
        border.width: 0

        onClicked: titleClicked()
        onDoubleClicked: titleDoubleClicked()
        onLongClicked: titleLongClicked()
    }
    
    PPushButton {
        id: rightButton

        anchors.verticalCenter: parent.verticalCenter
        anchors.right: parent.right
        anchors.rightMargin: PTheme.marginSizeNormal

        iconPointSize: PTheme.iconSizeSmall
        onClicked: header.rightButtonClicked()
    }
}
