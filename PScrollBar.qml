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
    id: scrollbar

    //color: 'black'
    property Flickable target

    property var colorSwatch: PTheme.currentColorSwatch

    property real progress: trackTargetAlong === Qt.Horizontal? 
                              target.contentX/target.contentWidth : 
                              target.contentY/target.contentHeight

    property real windowSize: trackTargetAlong === Qt.Horizontal?
                                target.width/target.contentWidth :
                                target.height/target.contentHeight

    opacity: progress < 1 && target.flicking? 1 : 0
    Behavior on opacity{ NumberAnimation{ duration: PTheme.animationDuration } }

    property int orientation: Qt.Vertical
    property int trackTargetAlong: Qt.Vertical
    property int thickness: 3

    x: orientation === Qt.Horizontal? 0 : target.width - thickness
    width: orientation === Qt.Horizontal? target.width : thickness
    height: orientation === Qt.Horizontal? thickness : target.height 
    
    clip: true

    Rectangle {
      id: content
      

      x: orientation === Qt.Horizontal? scrollbar.width*progress : 0
      y: orientation === Qt.Horizontal? 0 : scrollbar.height*progress

      width: orientation === Qt.Horizontal? scrollbar.width*windowSize :
                                            parent.height

      height: orientation === Qt.Horizontal? parent.height :
                                             scrollbar.height*windowSize
                                            
      color: colorSwatch.base
    }
}
