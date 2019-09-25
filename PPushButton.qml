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
    property alias label: buttonText.label
    property alias icon: iconText.label
    property string iconPath: ''

    property bool labelNextToIcon: true
    
    property alias iconPointSize: iconText.font.pointSize
    property alias labelPointSize: buttonText.font.pointSize
    property alias labelPixelSize: buttonText.font.pixelSize
    property alias labelBoldText: buttonText.font.bold
    
    property alias pressed: mouseArea.pressed
    
    signal clicked()
    signal longClicked()
    signal doubleClicked()

    property string contentColor: pressed? PTheme.invertedTextColor : PTheme.highlightedTextColor
    
    property var colorSwatch: PTheme.currentColorSwatch
    color: !enabled?          PTheme.inactiveBackgroundColor:
           mouseArea.pressed? colorSwatch.dark :
                              colorSwatch.base

    width: content.width + 2*PTheme.marginSizeNormal
    height: content.height + 2*PTheme.marginSizeNormal
    property int spacing: (icon === '' && iconPath ==='')^(label === '')? 0 : PTheme.characterWidthNormal
    
    border.color: 'transparent'

    enabled: visible

    Item {
        id: content

        width: labelNextToIcon? image.width + buttonText.width + spacing:
                                Math.max(image.width, buttonText.width)
        height: labelNextToIcon? Math.max(image.height, buttonText.height) :
                                 image.height + buttonText.height + spacing
        anchors.centerIn: parent

        Item {
            id: image
            x: labelNextToIcon? 0 : content.width/2 - image.width/2
            y: labelNextToIcon? Math.max(content.height/2 - image.height/2, 0) : 0
            width: icon? iconText.width : iconImage.width
            height: icon? iconText.height : iconImage.height
            Image {
                id: iconImage
                source: icon? '' : iconPath
            }
            PLabel {
                id: iconText
                font.pointSize: PTheme.iconSizeNormal
                font.family: FontAwesome.fontName
                color: enabled? contentColor : PTheme.inactiveTextColor
            }
        }

        PLabel {
            id: buttonText
            font.pointSize: PTheme.fontSizeNormal
            x: labelNextToIcon? image.width + spacing : content.width/2 - buttonText.width/2
            y: labelNextToIcon? Math.max(content.height/2 - buttonText.height/2, 0) : image.height + spacing
            color: enabled? contentColor : PTheme.inactiveTextColor
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        onClicked: parent.clicked()
    }
}
