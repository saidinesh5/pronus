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
    id: comboBoxDialog

    title: 'Select an Item'

    property alias currentIndex: items.currentIndex
    property alias model: items.model
    property bool searchable: true

    Item {
        id: content

        anchors.fill: parent
        anchors.margins: PTheme.marginSizeLarge

        opacity: visible? 1 : 0
        Behavior on opacity { NumberAnimation {duration: PTheme.animationDuration} }

        PLabel {
            id: titleLabel

            //color: 'transparent'

            font.pointSize: PTheme.fontSizeLarge
            color: PTheme.invertedTextColor
            
            anchors.left: parent.left
            anchors.right: cancelButton.left
            anchors.top: parent.top
            anchors.topMargin: PTheme.marginSizeLarge

            label: comboBoxDialog.title
        }
        
        PPushButton {
            id: cancelButton

            anchors.right: parent.right
            anchors.top: parent.top
            anchors.bottom:titleSeparator.top
            
            color: 'transparent'
            border.width: 0
            
            icon: FontAwesome.icon.close
            
            onClicked: done(-1)
        }
        
        Rectangle
        {
          id: titleSeparator
          
          anchors.top: titleLabel.bottom
          anchors.left: parent.left
          anchors.right: parent.right
          anchors.margins: PTheme.marginSizeNormal
          height: 1
          color: PTheme.invertedTextColor
        }

        ListView {
            id: items

            anchors.top: titleSeparator.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.margins: PTheme.marginSizeNormal

            clip: true

            currentIndex: -1

            delegate: PPushButton {
                id: listItem
                
                property bool isSelected: items.currentIndex == index
                
                border.width: 0
                radius: 0

                width: content.width
                height: PTheme.characterHeightNormal*2
                color: isSelected? colorSwatch.base : 'transparent'
                contentColor: isSelected? PTheme.textColor : PTheme.invertedTextColor
                
                label: modelData

                onClicked: {
                    done(index)
                }
            }
        }
        
        PScrollBar {
            target: items
        }
    }
}
