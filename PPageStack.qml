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
    id: pageStackModel

    /**
    *  Pushes a page onto the page stack.
    *
    *  Each Page must be a component based on Page.qml
    *
    *  @pageSource : The name of the qml file to be loaded.
    *  @properties : A list of key-value pairs to initialize the page with
    *
    **/
    function pushPage(pageSource, properties) {
        if(!properties) properties = {}
        pageStackModel.append({ 'componentPath': pageSource,
                                'properties': JSON.stringify(properties)})
    }

    /**
    * Pops the last page from the page stack
    */
    function popPage(){
        var lastElement = Math.max(0,pageStackModel.count - 1)
        pageStackModel.remove(lastElement)
    }

    /**
    * Pops any open dialogs to goto the homescreen
    */
    function gotoHome(){
        while(pageStackModel.count > 0)
            popPage()
    }
    
    //Contains items like:
    //ListElement{ componentPath: 'Page1.qml'; properties: '{"title": "Hello"}'  }
}
