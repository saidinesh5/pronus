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

pragma Singleton
import QtQuick 2.0

ListModel {
    id: model

    /**
     * Contains something like:
     *    ListElement{
     *        componentPath: 'BMessageBox.qml'
     *        properties: '{"dialogId": 0, "title": "Hello There", "message": "Howdy" }'
     *    }
     * Each ListElement has a callback function associated with it
     */
    property var callbacks: []
    

    /**
     * Show the PMessageBox and calls the callback the function with the selected action
     * properties:
     *   string title: 'Hey'
     *   string message: 'Your Message Here!'
     *   var actions: ['OK']
     */
    function showMessageBox(properties, callback)
    {
        return showDialogBox('PMessageBox.qml', properties, callback)
    }
    
    /**
     * Show the file dialog box and callback the function with the selected file
     * properties:
     *   string title: 'Select File'
     *   bool showPreviews: false
     *   string folder: '/'
     *   string nameFilters: directly specify the filetypes you want to fileter''
     *   string fileTpeFilter: one of ['archive', 'audio','code', 'spreadsheet',
     *                                 'picture', 'pdf', 'richtext', 'slideshow', 'text', 'video']
     */
    function showFileDialog(properties, callback)
    {
        return showDialogBox('PFileDialog.qml', properties, callback)
    }

    /**
     * Show the file dialog box and callback function when done, with the result
     * The dialog box must be a Component based on PModalDialog
     * properties:
     *   string title: 'Hey'
     *   var actions: ['OK']
     */
    function showDialogBox(dialogSource, properties, callback)
    {
        if(properties === undefined)
            properties = {}

        if(properties['dialogId'])
        {
            console.error('You cannot use the property name dialogId')
            return -1
        }

        properties["dialogId"] = model.count

        callbacks.push(callback)
        model.append({ componentPath: dialogSource,
                       properties: JSON.stringify(properties)} )
        
        return model.count - 1
    }

    function returnDialog(index, result)
    {
        if(index < 0 || index >= callbacks.length)
            return False

        var callback = callbacks[index]

        callbacks.splice(index,1)
        model.remove(index)

        if(callback !== undefined)
            callback(result)
    }
}
