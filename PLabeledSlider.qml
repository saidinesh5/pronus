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
    id: labeledSlider
    
    property real value
    property real minValue: 1
    property real maxValue: 100

    property int steps: 100
    property real stepSize: (maxValue - minValue)/steps

    property alias tooltipMessage : stepSlider.tooltipMessage
    
    property alias orientation: stepSlider.orientation
    property alias colorSwatch: stepSlider.colorSwatch
    
    width: orientation === Qt.Horizontal?
          25*PTheme.characterWidthNormal : 3*PTheme.characterHeightNormal

    height: orientation === Qt.Horizontal?
            3*PTheme.characterHeightNormal : 25*PTheme.characterWidthNormal

    property var labels: ListModel {
        ListElement { label: "0";   position: 0.  }
        ListElement { label: "1";   position: 1.0  }
    }
    property var values: ListModel {
        ListElement { value: 0.0; position: 0.0 }
        ListElement { value: 1.0; position: 1.0 }
    }

    property alias interacting: stepSlider.interacting
    signal pressed()
    signal released()

    onValueChanged: updatePosition()

    function updatePosition(){
        var result = convert(labeledSlider.value,'value','position')
        result = Math.min(Math.max(result, stepSlider.minValue), stepSlider.maxValue)
        stepSlider.value = result
    }

    function convert(v, from, to){
        if(!from || !to){
            from = 'value'
            to = 'position'
        }

        if(values.count < 2){
            console.log("Not Enough values to transform the value: ", v)
            return -1
        }

        var lowerBound = { 'value': -Infinity, 'position': -Infinity}
        var upperBound = { 'value': Infinity, 'position': Infinity}

        for(var i = 0; i < values.count; i++){
            var element = values.get(i)
            if(v <= element[from] && element[from] <= upperBound[from])
                upperBound = element
            if(v >= element[from] && element[from] >= lowerBound[from])
                lowerBound = element
        }

        if( Math.abs(upperBound[from] - lowerBound[from]) < 0.000000001)
            return lowerBound[to]

        var normalized =  (v - lowerBound[from])/(upperBound[from] - lowerBound[from])
        return normalized*(upperBound[to] - lowerBound[to]) + lowerBound[to]
    }

    Repeater {
        model: labels
        anchors.horizontalCenter: parent.horizontalCenter

        delegate: Item{
            x: orientation === Qt.Vertical?
                0: labeledSlider.width*(position)
            y: orientation === Qt.Vertical?
                labeledSlider.height*(1 - position): 0
            width: orientation === Qt.Vertical?
                     stepSlider.width + 2*PTheme.marginSizeNormal : 1
            height: orientation === Qt.Vertical?
                      1 : stepSlider.height + 2*PTheme.marginSizeNormal

            PLabel {
                x: orientation === Qt.Vertical? -width : parent.width
                y: orientation === Qt.Vertical? parent.height/2 - height/2 : parent.height - height/2
                horizontalAlignment: Text.AlignRight
                label: label
                font.pointSize: PTheme.fontSizeSmall
            }

            Rectangle {
                id: markerRect
                anchors.fill: parent
                color: PTheme.borderColor
            }
        }
    }

    PStepSlider {
        id: stepSlider
        
        anchors.fill: parent
        anchors.leftMargin: orientation === Qt.Vertical? PTheme.marginSizeNormal : 0
        anchors.rightMargin: anchors.leftMargin
        anchors.topMargin: orientation === Qt.Vertical? 0 : PTheme.marginSizeNormal
        anchors.bottomMargin: anchors.topMargin
        steps: 2*labeledSlider.steps
        minValue: 0
        maxValue: 1

        onValueChanged: {
            var result = convert(stepSlider.value,'position','value')
            var stepSize = labeledSlider.stepSize
            result = Math.round(result/stepSize)*stepSize
            result = Math.min(Math.max(result,labeledSlider.minValue),labeledSlider.maxValue)

            if(stepSlider.interacting)
                labeledSlider.value = result

        }

        onPressed: labeledSlider.pressed()
        onReleased: labeledSlider.released()
    }

    Component.onCompleted: {
        var minimum = Infinity
        var maximum = -Infinity
        for( var i = 0; i < values.count; i++){
            var element = values.get(i).value
            if(element < minimum)
                minimum = element
            if(element > maximum)
                maximum = element
        }

        minValue = minimum
        maxValue = maximum

        updatePosition()
    }
}
