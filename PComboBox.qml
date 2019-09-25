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
    id: comboBox

    property var dataModel: ['']
    property bool expanded: false

    property int currentIndex: -1
    readonly property string currentItem: dataModel[currentIndex]

    enabled: dataModel && dataModel.length > 0
    clip: false

    property var colorSwatch: PTheme.currentColorSwatch

    function largestItem(model)
    {
        var result = ''
        for(var i in model)
            result = model[i].length > result.length? model[i] : result
        return result
    }

    width: PTheme.characterWidthNormal*(largestItem(dataModel).length + 2)
    height: PTheme.characterHeightNormal*2
    z: expanded? PTheme.raisedZValue : 0
    Behavior on z { NumberAnimation{ duration: PTheme.animationDuration } }

    PContentRectangle {
        id: contentRectangle
        width: parent.width
        height: expanded? parent.height*dataModel.length : parent.height
        radius: comboBox.radius

        clip: true

        Behavior on height { NumberAnimation { duration: PTheme.animationDuration } }
        
        PLabel {
            anchors.fill: parent
            anchors.margins: PTheme.marginSizeNormal
            label: currentItem
        }


        MouseArea {
            anchors.fill: parent
            onClicked:
            {
                PModalDialogs.showDialogBox('PComboBoxDialog.qml', { 
                    title: 'Select a theme',
                    model: dataModel,
                    currentIndex: currentIndex
                },
                  function(result)
                  {
                      if(result >= 0 && result < dataModel.length)
                        currentIndex = result
                  }
                )
            }
        }

        PLabel
        {
            label: FontAwesome.icon.angle_down
            font.family: FontAwesome.fontName
            anchors.right: parent.right
            anchors.rightMargin: PTheme.marginSizeNormal
            anchors.verticalCenter: parent.verticalCenter
            opacity: expanded? 0 : 1
            Behavior on opacity { NumberAnimation { duration: PTheme.animationDuration } }
        }
    }
}
