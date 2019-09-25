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

Item {
    property int currentDialogId: 0
    property var dialogs: ({}) // with dialog-entries: {dialogId: dialog}

    /**
     * Creates a modal dialog pointed by the dialogSource qml file.
     * For this functioanlity to work, the dialogSource MUST be an instance of PDialog component
     * properties are the json that will be passed on to the dialogSource' component
     * property must not contain a key called 'dialogId'
     * One of the properties of the dialog can be 'dialogTag', which can be used to find your particular dialog
     * eg. destroyDialogs('errorDialogs'), foreach('warningDialogs', function(dialog)(dialog.show()))
     * callback is the callback function that will be called with the result,
     * once the user finishes interacting with the dialog. (eg. confirms/dismisses and event)
     **/
    function showDialog(dialogSource, properties, callback) {
        if (properties === undefined) {
            properties = {}
        }

        if (properties['dialogId']) {
            console.error('You cannot use the property name dialogId')
            return -1
        }

        properties['dialogId'] = ++currentDialogId
        properties['callback'] = callback

        var dialog
        var component = Qt.createComponent(dialogSource)
        var result = -1
        if (component.status === Component.Ready) {
            dialog = component.createObject(properties['parent']
                                            ? properties['parent']
                                            : parent,
                                            properties)
            result = dialog.dialogId
            dialogs[result] = dialog
        }
        else {
            console.error(component.errorString())
        }

        return result
    }

    /**
     * Destroy the dialog with the given dialogId
     */
    function destroyDialog(dialogId) {
        if (dialogs[dialogId] === undefined) {
            return false
        }

        dialogs[dialogId].destroy()
        delete dialogs[dialogId]

        return true
    }

    /**
     * Destroys all dialogs with the given dialogTag and an optional callback test function
     * If dialogTag is empty, it destroys all dialogs
     * returns the number of dialogs that are destroyed
     */
    function destroyDialogs(dialogTag, callback) {
        if (typeof callback !== 'function') {
            callback = function(d) { return true }
        }

        var dialogIdsToDestroy = []

        for (var dialogId in dialogs) {
            var dialog = dialogs[dialogId]
            if (!dialogTag
                || (dialog.dialogTag === dialogTag
                    && callback(dialog))) {
                dialogIdsToDestroy.push(dialogId)
            }
        }

        for (var d in dialogIdsToDestroy) {
            destroyDialog(d)
        }

        return dialogIdsToDestroy.length
    }

    /**
     * Calls the callback function with every dialog whose dialogTag is dialogTag
     */
    function forEach(dialogTag, callback)
    {
        if (callback === undefined) {
            return
        }

        for (var dialogId in dialogs) {
            var dialog = dialogs[dialogId]
            if (!dialogTag
                || dialogTag === dialog.dialogTag) {
                callback(dialog)
            }
        }
    }
}
