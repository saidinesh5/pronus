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

import Qt.labs.folderlistmodel 2.0

PModalDialog {
    id: fileDialog

    title: 'Select File'

    property string fileTypeFilter: ''
    property bool showPreviews: false

    property alias folder: folderModel.folder
    property alias nameFilters: folderModel.nameFilters

    property var colorSwatch: PTheme.currentColorSwatch
    
    FolderListModel {
      id: folderModel
      showDotAndDotDot: false
      showDirsFirst: true
      nameFilters: {
          if(!commonFileTypes[fileTypeFilter] || commonFileTypes[fileTypeFilter].length < 1)
              return []

          commonFileTypes[fileTypeFilter].map(function(item){ return '*.'+ item })
      }

      onFolderChanged: folderContents.currentIndex = -1

      Component.onCompleted: {
          //FIXME: There seems to be some kind of race condition when the folder property is set
          var temp = folder.toString()
          if(temp.indexOf('file://') < 0)
              temp = 'file:///' + temp
          if(temp[temp.length-1] !== '/')
              temp += '/'
          //folder = ''
          folder = temp
      }

    }


    PContentRectangle {
        id: contentRectangle

        anchors.centerIn: parent

        opacity: visible? 1 : 0
        Behavior on opacity { NumberAnimation {duration: PTheme.animationDuration} }

        width: parent.width*0.9
        height: parent.height*0.9

        PLabel {
            id: titleLabel

            color: PTheme.textColor
            font.bold: true
            font.pointSize: PTheme.fontSizeLarge
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: PTheme.marginSizeLarge

            label: fileDialog.title
            maxLabelLength: parent.width/PTheme.characterWidthLarge
        }

        PContentRectangle {
            id: pathBar
            anchors.top: titleLabel.bottom
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.topMargin: PTheme.marginSizeNormal
            anchors.leftMargin: Math.max(PTheme.marginSizeNormal, parent.radius/2)
            anchors.rightMargin: anchors.leftMargin
            height: PTheme.characterHeightLarge*2

            color: PTheme.inactiveBackgroundColor

            ListView {
                id: currentPathView

                property string currentPath: folderModel.folder.toString().replace('file:///', '')

                model: ['/'].concat(currentPath.split('/').filter(function(i){ return i !== ''}))

                currentIndex: count - 1

                anchors.fill: parent
                anchors.margins: PTheme.marginSizeSmall

                orientation: ListView.Horizontal
                interactive: width < contentWidth

                clip: true

                delegate: Row {
                    PPushButton {
                        label: modelData
                        height: currentPathView.height
                        anchors.verticalCenter: parent.verticalCenter
                        onClicked: {
                            var nextPathParents = currentPathView.model.slice(0, index + 1)
                            var nextPath =  nextPathParents.join('/')

                            if(nextPath.indexOf('file:/') < 0)
                                nextPath = 'file:/' + nextPath

                            nextPath += '/'

                            folderModel.folder = nextPath
                        }
                    }
                    PLabel {
                        label: ' / '
                        color: PTheme.inactiveTextColor
                        anchors.verticalCenter: parent.verticalCenter
                    }
                }
            }
        }

        ListView {
            id: folderContents

            model: folderModel

            anchors.top: pathBar.bottom
            anchors.bottom: actionButtons.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: PTheme.marginSizeNormal

            clip: true

            currentIndex: -1

            property string selectedFilePath:  currentIndex >= 0?
                                                   'file://' + folderModel.get(currentIndex, 'filePath') :
                                                   ''

            delegate: PContentRectangle {
                id: fileItem

                property bool isSelected: folderContents.currentIndex === index

                width: folderContents.width
                height: PTheme.characterHeightNormal*2 + Math.max(fileDetails.height, iconLabel.height)
                color: isSelected? colorSwatch.base : 'transparent'
                border.width: 0

                Image {
                    id: previewImage
                    asynchronous: true
                    visible: showPreviews && isSelected && fileType(fileSuffix) === 'picture'
                    anchors.left: parent.left
                    anchors.margins: PTheme.marginSizeNormal
                    anchors.verticalCenter: parent.verticalCenter
                    width: visible? Math.max(iconLabel.width, iconLabel.height) : 0
                    height: visible? width : 0
                    source: visible? 'file://' + filePath : ''
                    sourceSize: Qt.size(256,256)
                }

                PLabel {
                    id: iconLabel
                    visible: !previewImage.visible
                    anchors.left: previewImage.right
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.margins: PTheme.marginSizeNormal
                    font.family: FontAwesome.fontName
                    label: fileIsDir? FontAwesome.icon.folder : fileIcon(fileSuffix)
                    color: isSelected? PTheme.invertedTextColor : PTheme.textColor
                    font.pointSize: isSelected? PTheme.iconSizeNormal : PTheme.iconSizeSmall
                }

                Column {
                    id: fileDetails
                    anchors.left: parent.left
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.leftMargin: Math.max(iconLabel.width, previewImage.width) + 4*PTheme.marginSizeNormal
                    anchors.rightMargin: PTheme.marginSizeNormal

                    spacing: PTheme.marginSizeSmall
                    PLabel {
                        id: fileNameLabel
                        label: fileName
                        color: iconLabel.color
                        font.pointSize: isSelected? PTheme.fontSizeLarge : PTheme.fontSizeNormal
                        maxLabelLength: isSelected? parent.width/PTheme.characterWidthLarge : parent.width/PTheme.characterWidthNormal
                    }

                    PLabel {
                        id: fileSizeLabel
                        label: 'Size: ' + fileSize
                        visible: isSelected
                        color: iconLabel.color
                        font.pointSize: PTheme.fontSizeSmall
                    }

                    PTimeLabel {
                        prefix: 'Last modified: '
                        font.pointSize: PTheme.fontSizeSmall
                        timestamp: fileModified
                        visible: isSelected
                        color: iconLabel.color
                        maxLabelLength: parent.width/PTheme.characterWidthSmall
                    }
                }

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        if(fileIsDir)
                        {
                            folderModel.folder = 'file://'+filePath +'/'
                        }
                        else
                        {
                            //Toggle selection
                            folderContents.currentIndex = isSelected? -1 : index
                        }
                    }

                    onDoubleClicked: {
                        if(!fileIsDir)
                            done(folderContents.selectedFilePath)
                    }
                }
            }
        }

        Row {
            id: actionButtons
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: PTheme.marginSizeLarge
            anchors.bottomMargin: PTheme.marginSizeLarge

            PPushButton {
                id: okButton
            
                label: 'Ok'
                labelPointSize: PTheme.fontSizeLarge

                width: fileDialog.width/4

                enabled: folderContents.selectedFilePath !== ''

                onClicked:
                {
                    fileDialog.visible = false
                    done(folderContents.selectedFilePath)
                }
            }

            PPushButton {
                id: cancelButton

                width: fileDialog.width/4

                label: 'Cancel'
                labelPointSize: PTheme.fontSizeLarge
                onClicked:
                {
                    fileDialog.visible = false
                    done('')
                }
            }

        }

    }

    property var commonFileTypes : {
        'archive': ['7z', 'cbr', 'deb', 'gz', 'pkg', 'rar', 'rpm', 'tar.gz', 'zip', 'zipx', 'xz'],
        'audio': ['aac', 'mid', 'ogg', 'flac', 'aif', 'iff', 'm3u', 'm4a', 'mpa', 'ra', 'wav', 'wmv'],
        'code': ['c', 'cc', 'class', 'cpp', 'cs', 'dtd', 'fla', 'h', 'java', 'lua', 'm', 'pl', 'py', 'sh',
                 'sln', 'swift', 'vsxproj', 'asp', 'aspx', 'cer', 'cfm', 'csr', 'css', 'htm', 'html', 'js',
                 'js', 'jsp', 'php', 'qml', 'xhtml'],
        'spreadsheet': ['xls', 'xlsx', 'xlr', 'csv'],
        'picture': ['bmp','gif', 'jpg', 'jpeg', 'png','webp'],
        'pdf': ['pdf'],
        'richtext': ['doc', 'docx', 'odt', 'rtf', 'wps'],
        'slideshow': ['odp', 'ppt', 'pptx'],
        'text': ['ini','json','txt','xml'],
        'video': ['3g2', '3gp', 'asf', 'asx', 'avi', 'flv', 'm4v', 'mkv', 'mov', 'mp4', 'mpg', 'mpeg', 'rm',
                  'swf', 'vob', 'webm', 'wmv' ]
    }

    property var fileExtensionTypeMap

    function fileType(suffix){
        suffix = suffix? suffix.toLowerCase() : ''
        if(!fileExtensionTypeMap)
        {
            fileExtensionTypeMap = {}
            for(var type in commonFileTypes)
            {
                var extensions = commonFileTypes[type]
                for(var i in extensions)
                    fileExtensionTypeMap[extensions[i]] = type
            }
        }

        return fileExtensionTypeMap[suffix]? fileExtensionTypeMap[suffix] : ''
    }

    function fileIcon(suffix) {
        var type = fileType(suffix)

        switch(type){
        case 'archive': return FontAwesome.icon.file_archive_o
        case 'audio': return FontAwesome.icon.file_audio_o
        case 'code': return FontAwesome.icon.file_code_o
        case 'spreadsheet': return FontAwesome.icon.file_excel_o
        case 'picture': return FontAwesome.icon.file_image_o
        case 'pdf': return FontAwesome.icon.file_pdf_o
        case 'richtext': return FontAwesome.icon.file_word_o
        case 'slideshow': return FontAwesome.icon.file_powerpoint_o
        case 'text': return FontAwesome.icon.file_text_o
        case 'video': return FontAwesome.icon.file_video_o
        default: return FontAwesome.icon.file_o
        }
    }
}
