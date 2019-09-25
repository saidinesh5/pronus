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
    /**
    * The main GUI Manager.
    * Provides the app with a tab view(+ tab bar) and a page stack.
    * Pages can be added and removed dynamically from the tabview and pagestack
    *
    **/

    id: bootflatApplication
    width: 1024
    height: 768

    property alias title : header.title
    property alias showNotifications: notificationBar.visible
    property alias homePageComponent: homePage.sourceComponent
    property alias homecomponentPath: homePage.source

    property int pageCount: PPageStack.count
    property var currentPage: pageCount > 0 ?
                                pageStack.itemAt(pageCount - 1).item:
                                homePage.item

    Loader {
        id: homePage

        property var gDialogs: gDialogs

        anchors.top: header.bottom
        anchors.bottom: parent.bottom
        anchors.right: sideMenu.left
        width: parent.width
    }

    Repeater {
        id: pageStack
        model: PPageStack
        delegate: Loader {
            id: page

            property var gDialogs: gDialogs

            visible: index === PPageStack.count - 1
            anchors.fill: parent
            anchors.topMargin: header.height
            anchors.rightMargin: sideMenu.width
            Component.onCompleted: page.setSource( componentPath, JSON.parse(properties))
        }
    }

    //For integration with Android's back key
    focus: true
    Keys.onReleased: {
        if(event.key === Qt.Key_Back)
        {
            if(PModalDialogs.count > 0) PModalDialogs.returnDialog(PModalDialogs.count - 1)
            else if(pageCount > 0) PPageStack.popPage()
            else Qt.quit()
            event.accepted = true
        }
    }

    PHeader {
        id: header

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top

        title: currentPage.title
        
        onTitleClicked: currentPage.titleClicked()
        onTitleDoubleClicked: currentPage.titleDoubleClicked()

        leftButtonVisible: pageCount !== 0 && Qt.platform.os !== 'android'
        leftButtonLabel: qsTr('Back')
        onLeftButtonClicked: PPageStack.popPage()
        
        rightButtonIcon: FontAwesome.icon.align_justify
        rightButtonVisible: currentPage.menuModel && currentPage.menuModel.count > 0
        onRightButtonClicked: sideMenu.toggle()
    }

    PSideMenu {
        id: sideMenu
        anchors.top: header.bottom
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        
        menuModel: currentPage.menuModel
        onActionSelected: currentPage.actionSelected(action)
    }

    PNotificationBar {
        id: notificationBar

        anchors.fill: parent
        anchors.topMargin: header.height
    }

    PModalDialogs { id: gDialogs }
}
