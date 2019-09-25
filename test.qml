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
import QtQuick.Window 2.0
import '.'

Window {
    width: 480
    height: 800

    PApplication {
        id: root
        anchors.fill: parent

        //color: 'lightgrey'
        homePageComponent: PPage {
          id: page
          
          menuModel: ListModel{
              ListElement{
                  //icon: FontAwesome.icon.cog
                  action: 'settings'
                  label: 'Settings'
              }
          }

          Flickable {
            id: flickable
            anchors.fill: parent
            anchors.margins: 10
            contentWidth: content.width
            contentHeight: content.height
            flickableDirection: Flickable.VerticalFlick
                Grid {
                    id: content
                    columns: 2
                    //columnSpacing: page.width*0.25
                    spacing: PTheme.marginSizeLarge

                    PLabel{ text: 'Checkbox';font.bold: true }
                    PCheckBox { isOn: true }

                    PLabel{ text: 'Combobox';font.bold: true }
                    PComboBox {
                        dataModel: PTheme.availableColorSwatches
                        currentIndex: 0
                        onCurrentItemChanged: PTheme.currentColorSwatch = PTheme.colorSwatches[currentItem]
                    }

                    PLabel { text: 'LineEdit';font.bold: true }
                    PLineEdit{ width: parent.width/3; displayText: 'Type something here...' }

                    PLabel{ text: 'PushButton';font.bold: true }
                    Flow {
                        width: page.width*0.6
                        spacing: 10
                        PPushButton {
                            label: 'Notify success'
                            onClicked: PNotifications.postNotification('success', 'Hello There! This is a success.')
                        }
                        PPushButton {
                            icon: FontAwesome.icon.fonticons
                            iconPointSize: PTheme.iconSizeSmall
                            onClicked: PNotifications.postNotification('error', 'Hello There! This is an error!!')

                            PTooltip { label: 'Notify warning.'; position: 'right' }
                        }
                        PPushButton {
                            icon: FontAwesome.icon.fonticons;
                            label: 'Notify Warning'
                            iconPointSize: PTheme.iconSizeNormal
                            onClicked: PNotifications.postNotification('warning', 'Hello There! This is a warning!')
                        }
                        PPushButton {
                            icon: FontAwesome.icon.fonticons;
                            label: 'Notify info'
                            labelNextToIcon: false; iconPointSize: PTheme.iconSizeLarge
                            onClicked: PNotifications.postNotification('info', 'Hello There! This is a notification.')
                        }
                    }

                    PLabel { text: 'Switch';font.bold: true }
                    PSwitch { isOn: true }

                    PLabel { text: 'TimeLabel';font.bold: true }
                    PTimeLabel {
                        prefix: 'Doomsday: ';
                        timestamp: new Date(2015, 07,04)
                    }

                    PLabel{ text: 'StepSlider'; font.bold: true }
                    PStepSlider { minValue: 1; maxValue: 100; steps: 100 }

                    PLabel{ text: 'LabeledSlider'; font.bold: true }
                    PLabeledSlider { orientation: Qt.Horizontal }
                    
                    PLabel{ text: 'File Dialog'; font.bold: true }
                    PPushButton {
                        id: openFileButton
                        icon: FontAwesome.icon.folder_open
                        iconPointSize: PTheme.iconSizeNormal
                        onClicked: gDialogs.showDialog('PFileDialog.qml',
                                                       {
                                                           'title': 'Select an image...',
                                                           'fileTypeFilter': 'picture',
                                                           'showPreviews': true
                                                       },
                                                       function(result) { PNotifications.postNotification('info', 'Selected: ' + result) })
                    }
                }
            }

            PScrollBar { target: flickable; anchors.right: parent.right; height: page.height }
        }
        PTooltip { label: 'Notify warning.\nBtw. this is a tooltip' }
        //PSplash screen { }
        //Todo: TabView
    }
    
    Component.onCompleted: {
        var os = Qt.platform.os
        if(os === 'android' || os === 'ios' || os === 'blackberry')
            showMaximized()
        else show()
    }

}
