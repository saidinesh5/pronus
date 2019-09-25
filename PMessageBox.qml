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

PModalDialog {
    id: messageBox

    title: 'Hey'

    property string message: 'Your Message Here!'
    property var actions: ['OK']

    property var colorSwatch: PTheme.currentColorSwatch

    PContentRectangle {
        id: contentRectangle

        anchors.centerIn: parent

        opacity: visible? 0.95 : 0
        Behavior on opacity { NumberAnimation {duration: PTheme.animationDuration} }

        property int minWidth: messageBox.width/4
        property int maxWidth: 3*messageBox.width/4
        property int minHeight: messageBox.height/4
        property int maxHeight: 3*messageBox.height/4

        width: Math.min( Math.max( minWidth, Math.max(titleLabel.contentWidth, actionButtons.contentWidth)) + 2*PTheme.marginSizeLarge, maxWidth )
        height: Math.min ( Math.max( minHeight, 2*titleLabel.contentHeight + messageLabel.contentHeight + actionButtons.height ), maxHeight )

        PLabel {
            id: titleLabel

            color: PTheme.textColor
            font.bold: true
            font.pointSize: PTheme.fontSizeLarge
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: PTheme.marginSizeLarge

            label: messageBox.title
            maxLabelLength: Math.min(30, contentRectangle.maxWidth/PTheme.characterWidthLarge)
        }

        PLabel {
            id: messageLabel

            color: PTheme.textColor

            font.pointSize: PTheme.fontSizeNormal

            anchors.top: titleLabel.bottom
            anchors.bottom: actionButtons.top
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width

            label: messageBox.message
            maxLabelLength: 200

            wrapMode: Text.Wrap
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
        }

        ListView {
            id: actionButtons

            function largestItem( items ) {
                var result = ''
                for(var i in items)
                    if(items[i].length > result.length)
                        result = items[i]
               return result
            }
            property int buttonWidth: largestItem(messageBox.actions).length*PTheme.characterWidthLarge + 2*PTheme.marginSizeLarge
            width: buttonWidth*count + spacing*(count-1)
            height: PTheme.characterHeightNormal*3

            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            spacing: PTheme.marginSizeLarge
            clip: true

            orientation: ListView.Horizontal
            interactive: contentWidth > width

            model: messageBox.actions

            delegate:  PPushButton {
                id: actionButton

                label: modelData
                width: actionButtons.buttonWidth

                labelPointSize: PTheme.fontSizeLarge

                onClicked:
                {
                    messageBox.visible = false
                    done(modelData)
                }
            }
        }
    }
}
