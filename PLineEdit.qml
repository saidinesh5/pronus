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
    id: lineEdit

    property string displayText: ''
    property string editText: displayText

    property alias maximumLength: editBox.maximumLength
    property alias horizontalAlignment: editBox.horizontalAlignment
    property alias verticalAlignment: editBox.verticalAlignment
    property alias inputMethodHints: editBox.inputMethodHints
    property alias fontSize: editBox.font.pointSize
    property alias fontColor: editBox.color

    signal textAccepted(string text)

    clip:true

    width: 100
    height: PTheme.characterHeightNormal*2

    TextInput{
        id: editBox
        anchors.fill: parent
        anchors.leftMargin: PTheme.marginSizeNormal
        anchors.rightMargin: PTheme.marginSizeNormal
        font.pointSize: PTheme.fontSizeNormal
        font.family: PTheme.fontName

        color: enabled? PTheme.textColor : PTheme.inactiveTextColor

        verticalAlignment: TextInput.AlignVCenter
        inputMethodHints: Qt.ImhNoPredictiveText

        text: lineEdit.displayText
        onAccepted: acceptText()

        function acceptText(){
            lineEdit.textAccepted(text)
            focus = false
            Qt.inputMethod.hide()
        }

    }

    state : editBox.focus? 'editing' : ''

    states : [
        State {
            name: "editing"
            PropertyChanges {
                target: editBox
                text: editText
            }
        }
    ]

    transitions: [
        Transition {
            from: ""
            to: "editing"
            ScriptAction {
                script: editBox.cursorPosition = editText.length
            }
        },
        Transition {
            from: "editing"
            to: ""
            ScriptAction {
                script: editBox.acceptText()
            }
        }
    ]

    function handoverFocus()
    {
        //Handover focus to the root
        var current = lineEdit
        while(current.parent != null)
            current = current.parent
        current.focus = true
    }

    Component.onDestruction: {
        handoverFocus()
    }

}
