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
    id: modalDialog

    visible: false

    readonly property int dialogId: 0
    property string dialogTag: ''
    property var callback: null
    property string title: 'Hello There'

    signal done(var result)

    anchors.fill: parent

    function requestDestruction()
    {
        done({})
    }

    onDone:
    {
        if (callback
            && typeof callback === 'function')
        {
            callback(result)
        }

        gDialogs.destroyDialog(dialogId)
    }

    Rectangle {
        id: translucentBackground
        anchors.fill: parent
        color: 'black'

        opacity: modalDialog.visible? 0.75 : 0
        Behavior on opacity { NumberAnimation { duration: PTheme.animationDuration } }
    }

    MouseArea {
        //To grab all input
        anchors.fill: parent
        propagateComposedEvents: false
    }
    
    z: PTheme.raisedZValue

    Component.onCompleted: visible = true
    Component.onDestruction:
    {
        //Ugly but meh
        if (gDialogs.dialogs[dialogId])
        {
            delete gDialogs.dialogs[dialogId]
        }
    }
}
