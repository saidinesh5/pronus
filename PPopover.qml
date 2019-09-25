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

Canvas {
    id: tooltip
    
    property alias contentComponent: content.sourceComponent

    z: PTheme.raisedZValue
    
    property Item target: parent

    property string position: 'top' //['top', 'bottom', 'left', 'right']

    x: position === 'top' ||  position === 'bottom'? (target.width - width)/2 :
       position === 'left'?   -width :
       position === 'right'?  target.width :
                              0

    y: position === 'left' || position === 'right'? (target.height - height)/2 :
       position === 'top'?    -height :
       position === 'bottom'? target.height :
                              0

    width: content.item.width + 2*PTheme.marginSizeNormal + mLeft + mRight
    height: content.item.height + 2*PTheme.marginSizeNormal + mTop + mBottom

    property int triangleHeight: PTheme.marginSizeNormal
    property int triangleWidth: PTheme.marginSizeNormal
    
    property int mTop: position === 'bottom'? triangleHeight : 0
    property int mRight: position === 'left'? triangleHeight : 0
    property int mBottom: position === 'top'? triangleHeight : 0
    property int mLeft: position === 'right'? triangleHeight : 0

    onWidthChanged: requestPaint()
    onHeightChanged: requestPaint()

    onPaint: {
        var c = getContext('2d')

        var w = width, h = height
        var r = PTheme.roundedness*Math.min(h,w)*0.5
        c.reset()

        c.fillStyle = PTheme.invertedBackgroundColor
        c.beginPath()

        if(position === 'bottom') //The triangle is at top then
        {
            c.moveTo(r, mTop)
            c.lineTo(w/2 - triangleWidth/2, mTop)
            c.lineTo(w/2, 0)
            c.lineTo(w/2 + triangleWidth/2, mTop)
            c.lineTo(w - r, mTop)
        }
        else
        {
            c.moveTo(mLeft + r, mTop)
            c.lineTo(w - mRight - r, mTop)
        }

        c.quadraticCurveTo(w - mRight, mTop, w - mRight, mTop + r)

        if(position === 'left')
        {
            c.lineTo(w - mRight, h/2 - triangleWidth/2)
            c.lineTo(w, h/2)
            c.lineTo(w - mRight, h/2 + triangleWidth/2)
            c.lineTo(w - mRight, h - r)
        }
        else
        {
            c.lineTo(w - mRight, h - mBottom - r)
        }

        c.quadraticCurveTo(w - mRight, h - mBottom, w - mRight - r, h - mBottom)

        if(position === 'top')
        {
            c.lineTo(w/2 + triangleWidth/2, h - mBottom)
            c.lineTo(w/2, h)
            c.lineTo(w/2 - triangleWidth/2, h - mBottom)
            c.lineTo(r, h - mBottom)
        }
        else
        {
            c.lineTo(mLeft + r, h - mBottom)
        }

        c.quadraticCurveTo(mLeft, h - mBottom, mLeft, h - mBottom - r)

        if(position === 'right')
        {
            c.lineTo(mLeft, height/2 + triangleWidth/2)
            c.lineTo(0, height/2)
            c.lineTo(mLeft, height/2 - triangleWidth/2)
            c.lineTo(mLeft, r)
        }
        else
        {
            c.lineTo(mLeft, mTop + r)
        }

        c.quadraticCurveTo(mLeft, mTop, mLeft+r, mTop)
        c.closePath()
        c.fill()
    }

    Loader {
      id: content
      x: mLeft + PTheme.marginSizeNormal
      y: mTop + PTheme.marginSizeNormal
    }


    Behavior on opacity { NumberAnimation {duration: PTheme.animationDuration} }
}
