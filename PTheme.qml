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

Item {

    readonly property var colorSwatches : {
        'bluejeans':        { 'base': '#5D9CEC', 'dark': '#4A89DC' },
        'aqua':             { 'base': '#4FC1E9', 'dark': '#3BAFDA' },
        'mint':             { 'base': '#48CFAD', 'dark': '#37BC9B' },
        'grass':            { 'base': '#A0D468', 'dark': '#8CC152' },
        'sunflower':        { 'base': '#FFCE54', 'dark': '#F6BB42' },
        'bittersweet':      { 'base': '#FC6E51', 'dark': '#E9573F' },
        'grapefruit':       { 'base': '#ED5565', 'dark': '#DA4453' },
        'lavender':         { 'base': '#AC92EC', 'dark': '#E6E9ED' },
        'pinkrose':         { 'base': '#EC87C0', 'dark': '#D770AD' },
        'lightgray':        { 'base': '#F5F7FA', 'dark': '#E6E9ED' },
        'mediumgray':       { 'base': '#CCD1D9', 'dark': '#AAB2BD' },
        'darkgray':         { 'base': '#656D78', 'dark': '#434A54' }
    }

    readonly property var alertColors: {
        'info': colorSwatches.aqua,
        'warning': colorSwatches.sunflower,
        'success': colorSwatches.grass,
        'error': colorSwatches.bittersweet
    }

    property var availableColorSwatches: ['bluejeans', 'aqua', 'mint', 'grass',
        'sunflower', 'bittersweet', 'grapefruit',
        'lavender', 'pinkrose', 'lightgray', 'mediumgray',
        'darkgray']

    property var currentColorSwatch: colorSwatches.bluejeans

    property string backgroundColor: 'white'
    property string borderColor: colorSwatches.mediumgray.base
    property string separatorColor: colorSwatches.mediumgray.base
    property string textColor: 'black'
    property string highlightedTextColor: 'white'

    property string inactiveBackgroundColor: colorSwatches.lightgray.base
    property string inactiveTextColor: colorSwatches.mediumgray.dark

    property string invertedBackgroundColor: colorSwatches.darkgray.dark
    property string invertedTextColor: colorSwatches.lightgray.base

    property string invertedInactiveTextColor: colorSwatches.lightgray.dark

    property real roundedness: 0.25

    FontLoader {
      id: uiFont
      source: './resources/weblysleekuisl.ttf'
    }
    
    property alias fontName: uiFont.name
    
    property int fontSizeSmall: 11
    property int fontSizeNormal: 12
    property int fontSizeLarge: 22

    property int iconSizeSmall: 24
    property int iconSizeNormal: 48
    property int iconSizeLarge: 96

    Text {
        id: dummyTextSmall
        text: 'A'
        font.pointSize: fontSizeSmall
        font.family: fontName
        visible: false
    }
    readonly property int characterWidthSmall: dummyTextSmall.width
    readonly property int characterHeightSmall: dummyTextSmall.height
    readonly property int characterSizeSmall: Math.max(characterWidthSmall, characterHeightSmall)

    Text {
        id: dummyTextNormal
        text: 'A'
        font.pointSize: fontSizeNormal
        font.family: fontName
        visible: false
    }
    readonly property int characterWidthNormal: dummyTextNormal.width
    readonly property int characterHeightNormal: dummyTextNormal.height
    readonly property int characterSizeNormal: Math.max(characterWidthNormal, characterHeightNormal)

    Text {
        id: dummyTextLarge
        text: 'A'
        font.pointSize: fontSizeLarge
        font.family: fontName
        visible: false
    }
    readonly property int characterWidthLarge: dummyTextLarge.width
    readonly property int characterHeightLarge: dummyTextLarge.height
    readonly property int characterSizeLarge: Math.max(characterWidthLarge, characterHeightLarge)

    readonly property int marginSizeSmall: characterWidthSmall
    readonly property int marginSizeNormal: characterWidthNormal
    readonly property int marginSizeLarge: characterWidthLarge

    readonly property int raisedZValue: 100

    readonly property int animationDuration: 200
}
