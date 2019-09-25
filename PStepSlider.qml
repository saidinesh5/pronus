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
  id: slider
  
  width: orientation === Qt.Horizontal?
          25*PTheme.characterWidthSmall : 2*PTheme.characterHeightSmall

  height: orientation === Qt.Horizontal?
            2*PTheme.characterHeightSmall : 25*PTheme.characterWidthSmall

  property var colorSwatch: PTheme.currentColorSwatch

  property int steps : 11

  property real minValue: 0
  property real maxValue: 1
  property real value

  property real stepSize: (maxValue - minValue)/steps

  onValueChanged: updatePosition()
  onWidthChanged: updatePosition()
  onHeightChanged: updatePosition()

  function updatePosition() {
    //console.log("update position")
    var ratio = (slider.value - slider.minValue)/(slider.maxValue - slider.minValue)
    var stepSize = (slider.maxValue - slider.minValue)/(slider.steps - 1)
    var nextPos = knob.dragMin + ratio*(knob.dragMax - knob.dragMin)
    nextPos = Math.round(nextPos/stepSize)*stepSize
    nextPos = Math.min( Math.max(knob.dragMin,nextPos),knob.dragMax )

    if(knob.x !== nextPos)
      knob.x = nextPos
  }

  property alias tooltipMessage: tooltip.label

  property int orientation: Qt.Horizontal

  property bool isActive: steps >= 1 && value >= minValue && value <= maxValue

  property bool interacting: knob.pressed
  signal pressed()
  signal released()
  
  PContentRectangle {
    id: contentRectangle
    color: PTheme.inactiveBackgroundColor
    rotation: orientation === Qt.Horizontal? 0 : -90
    clip: false
    
    width: orientation === Qt.Horizontal? parent.width : parent.height
    height: orientation === Qt.Horizontal? parent.height: parent.width
    x: orientation === Qt.Horizontal? 0 : parent.width/2 - width/2
    y: orientation === Qt.Horizontal? 0 : parent.height/2 - height/2

    PContentRectangle {
      id: progressTrack

      width: knob.x + knob.width/2
      height: parent.height
      color: enabled? colorSwatch.base : PTheme.inactiveBackgroundColor

      opacity: 0.5 + 0.5*value/(maxValue - minValue)
    }

    PContentRectangle {
      id: knob

      property int dragMax: parent.width - knob.width
      property int dragMin: 0

      width:  Math.max(parent.width/steps, PTheme.characterWidthNormal)
      height: parent.height

      property bool pressed: mouseArea.pressed
      state : pressed? '':'released'

      clip: false

      MouseArea {
        id: mouseArea
        anchors.fill: parent

        drag.axis: Drag.XAxis
        drag.target: knob
        drag.minimumX: knob.dragMin
        drag.maximumX: knob.dragMax
        onPressed: slider.pressed()
        onReleased: slider.released()
      }

      PTooltip {
        id: tooltip
        label: parseInt(value*100)/100
        opacity: knob.pressed? 1.0 : 0.0
        visible: true
        target: parent
        position: orientation === Qt.Horizontal? 'top' : 'right'
        contentRotation: orientation === Qt.Horizontal? 0 : 90
      }


      onXChanged: {
        var ratio = (knob.x - knob.dragMin)/(knob.dragMax - knob.dragMin)
        var stepSize = (slider.maxValue - slider.minValue)/(slider.steps - 1)
        var nextValue = slider.minValue + ratio*(slider.maxValue - slider.minValue)
        nextValue = Math.round(nextValue/stepSize)*stepSize
        nextValue = Math.min(Math.max(slider.minValue, nextValue), slider.maxValue)

        if(slider.interacting && Math.abs(nextValue - slider.value)/stepSize >= 0.5 )
          slider.value = nextValue
        else slider.updatePosition()
      }
    }
  }
}
