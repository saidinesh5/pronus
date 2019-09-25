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
    id: tabView

    property alias currentTabIndex : menu.currentIndex
    property var tabs: Item {}

    function appendTab(tab, properties) {
        if(!properties) properties = {}
        tabModel.append({'tab': tab, 'properties': JSON.stringify(properties)})
    }

    function insertTab(index,tab, properties){
        if(!properties) properties = {}
        if(index<0)
            index = tabModel.count + index
        if(index <= tabModel.count)
            tabModel.insert( index, { 'tab': tab,
                                'properties': JSON.stringify(properties) })
        else appendTab(name,properties)
    }

    function tabIndex(tab){
        for(var i = 0; i < tabModel.count; i++)
            if(tabModel.get(i).tab === tab)
                return i
        return -1;
    }

    function removeTab(tab){
        for(var i = 0; i < tabModel.count; i++){
            if(tabModel.get(i).tab === tab){
                tabModel.remove(i)
                return
            }
        }
    }

    ListModel{
        id: tabModel
        //ListElement{ tab: 'Home'; properties: '{}' }
    }

    Repeater {
        id: tabs
        model: tabModel
        anchors.fill: parent
        delegate: Loader {
            id: tab
            property bool isActiveTab: (navigationBar.currentTabIndex === index)
            visible: isActiveTab
            anchors.fill: parent
            anchors.bottomMargin: tabBar.height
            Component.onCompleted: tab.setSource(tab, JSON.parse(properties))
            // TODO Look into fancy tab transition animation
            // opacity: isActiveTab? 1.0 : 0
            // Behavior on opacity { NumberAnimation {duration: 100} }
        }
    }

    ListView {
        id: tabBar
        height: parent.height
        width: tabs.count
        anchors.centerIn: parent

        model: tabs.count

        orientation: ListView.Horizontal
        clip: true

        interactive: width < contentWidth

        delegate: PPushButton {
            property bool selected: index === menu.currentIndex
            label: tabs.itemAt(index).item.name
            property string icon_selected: tabs.itemAt(index).item.icon_selected
            property string icon_normal: tabs.itemAt(index).item.icon_normal
            //onPressed: menu.currentIndex = index
        }
    }

}
