import QtQuick
import QtQuick.Controls

import desafio_treinamento_qmob

ApplicationWindow {
    id: window
    width: 412
    height: 732
    visible: true
    title: qsTr("Desafio Treinamento Qmob | Enoque Santos")

    //    Component.onCompleted: {
    //        var reply = Backend.http.get("https://qt.io")
    //        reply.onFinished.connect(function(response) {
    //            Backend.log("request response is:")
    //            Backend.log(response)
    //        })
    //    }

    header: Rectangle {
        id: header

        height: 50
        anchors {
            left: parent.left
            leftMargin: 5
            right: parent.right
            rightMargin: 5
        }

        Row {
            id: homeTitleAndButtonRow

            anchors {
                left: parent.left
                leftMargin: 5
                verticalCenter: parent.verticalCenter
            }

            IconButton {
                id: upButton

                text: stackView.depth > 1 ? MaterialIcons.mdiChevronLeft : MaterialIcons.mdiHome
                anchors.verticalCenter: parent.verticalCenter
                enabled: stackView.depth > 1
                hoverEnabled: enabled
                onClicked: stackView.backNavigation()
            }

            Label {
                id: homeLabel

                text: `${homeText} - ${projectText}`
                anchors.verticalCenter: parent.verticalCenter
                font.pointSize: 8

                readonly property string homeText: "Home"
                readonly property string projectText: "Qt Base (Core, Gui, Widgets, Network, ...)"

                MouseArea {
                    anchors.fill: parent
                    onClicked: {
                        while (stackView.depth > 1) {
                            stackView.pop()
                        }
                    }
                }
            }
        }

        ListView {
            id: breadcrumb

            anchors.verticalCenter: parent.verticalCenter
            orientation: Qt.Horizontal
            model: ListModel {
                id: breadcrumbListModel
            }
            delegate: ItemDelegate {
                onClicked: {
                    console.log("navigate to dir...")
                }

                Label {
                    text: dirName
                }
            }
        }
    }

    Component {
        id: gridViewComponent

        GridView {
            id: gridView

            property var modelData
            property StackView stackView

            cellWidth: window.width*0.20
            cellHeight: window.height*0.12
            model: ListModel {
                id: gridViewModel
            }
            delegate: FolderItemDelegate {
                width: gridView.cellWidth
                height: gridView.cellHeight
                onOpenDir: function(dirs, dirName) {
                    const args = {
                        modelData: dirs,
                        stackView: stackView
                    }

                    stackView.openNavigation(dirName, args)
                }
                onOpenFile: function(fileName, fileUrl) {
                    Qt.openUrlExternally(fileUrl)
                }
            }
            Component.onCompleted: {
                if (!Array.isArray(modelData)) {
                    modelData = [modelData]
                }
                for (var i = 0; i < modelData.length; ++i) {
                    gridViewModel.append({params: modelData[i]})
                }
            }
        }
    }

    Connections {
        target: stackView

        function onCurrentDirectoryChanged(dirName, isBackNavigation) {
            if (stackView.depth > 1) {
                homeLabel.text = homeLabel.homeText
            } else {
                homeLabel.text = `${homeLabel.homeText} - ${homeLabel.projectText}`
            }

            if (!isBackNavigation) {
                breadcrumbListModel.append({ dirName: dirName })
            } else {
                breadcrumbListModel.remove({ dirName: dirName })
            }
        }

        function onOpenDirRunning() {
            busyIndicator.running = true
        }

        function onOpenDirFinished() {
            lazyHideBusyIndicator.running = true
        }
    }

    Rectangle {
        color: "#ddd"
        anchors.fill: parent

        BusyIndicator {
            id: busyIndicator

            running: false
            anchors.centerIn: parent
            z: stackView.currentItem.z + 1
        }

        Timer {
            id: lazyHideBusyIndicator

            interval: 550
            onTriggered: busyIndicator.running = false
        }

        StackView {
            id: stackView

            anchors.fill: parent

            signal openDirRunning
            signal openDirFinished
            signal currentDirectoryChanged(string dirName, bool isBackNavigation)
            signal openNavigation(string dirName, var args)
            signal backNavigation

            onOpenNavigation: function(dirName, args) {
                // show BusyIndicator
                openDirRunning()

                push(gridViewComponent, args)
                internal.currentDirs.push(dirName)

                // ignore initial and first item
                if (depth > 1) {
                    currentDirectoryChanged(dirName, false)
                }

                // start lazy hide BusyIndicator
                openDirFinished()
            }
            onBackNavigation: {
                if (depth > 1) {
                    pop()
                    currentDirectoryChanged(internal.currentDirs.pop(), true)
                }
            }

            QtObject {
                id: internal

                property var currentDirs: []
                onCurrentDirsChanged: console.log(currentDirs)
            }
        }

        Component.onCompleted: stackView.openNavigation(Backend.loadJson(), {modelData: data, stackView: stackView})
    }
}
