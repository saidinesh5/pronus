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

ListView {
    id: notifications

    property bool expanded: false
    interactive: false
    
    model: PNotifications

    delegate: Rectangle {
        property bool exposed: index === notifications.count - 1 || notifications.expanded

        width: parent.width
        height: exposed? closeButton.height : 2

        color: PTheme.alertColors[level].base

        Behavior on height { NumberAnimation { duration: PTheme.animationDuration } }

        PPushButton {
            id: panelButton
            visible: index === notifications.count - 1 && notifications.count > 1
            opacity: visible? 1 : 0
            Behavior on opacity { 
              SequentialAnimation
              {
                  PauseAnimation{ duration: PTheme.animationDuration }
                  NumberAnimation{ duration: PTheme.animationDuration }
              }
            }

            icon: notifications.expanded? FontAwesome.icon.angle_double_up :''
            label: notifications.expanded? '' : notifications.count

            border.width: 0
            color: PTheme.backgroundColor
            contentColor: PTheme.textColor
            height: closeButton.height - PTheme.marginSizeSmall
            radius: height/2

            labelPointSize: PTheme.fontSizeLarge
            iconPointSize: labelPointSize

            anchors.left: parent.left
            anchors.leftMargin: PTheme.marginSizeNormal

            anchors.verticalCenter: parent.verticalCenter
            onClicked: notifications.expanded = !notifications.expanded
        }

        PLabel {
            id: messagePLabel

            label: message
            anchors.left: panelButton.right
            anchors.leftMargin: PTheme.marginSizeNormal
            anchors.verticalCenter: parent.verticalCenter

            visible: exposed
            opacity: visible? 1.0 : 0
            Behavior on opacity { NumberAnimation {duration: PTheme.animationDuration} }

            //color: PTheme.invertedTextColor
            //font.bold: true
        }

        PPushButton {
            id: closeButton
            icon: FontAwesome.icon.close

            visible: exposed

            opacity: visible? 1 : 0
            Behavior on opacity { 
              SequentialAnimation
              {
                  PauseAnimation{ duration: PTheme.animationDuration }
                  NumberAnimation{ duration: PTheme.animationDuration }
              }
            }

            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            color: 'transparent'
            border.color: 'transparent'

            iconPointSize: PTheme.iconSizeSmall

            onClicked: {
              if(index >= 0 && index < notifications.model.count)
                notifications.model.remove(index)
            }
        }
    }

    remove: Transition {
        NumberAnimation { property: "opacity"; to: 0; duration: PTheme.animationDuration }
    }
}

