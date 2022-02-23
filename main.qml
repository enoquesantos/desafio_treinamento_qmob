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
            id: homeRow

            z: 1
            anchors {
                left: parent.left
                leftMargin: 5
                verticalCenter: parent.verticalCenter
            }

            IconButton {
                text: stackView.depth > 1 ? MaterialIcons.mdiChevronUp : MaterialIcons.mdiHome
                anchors.verticalCenter: parent.verticalCenter
                enabled: stackView.depth > 1
                hoverEnabled: enabled
                onClicked: stackView.backNavigation()
                color: homeLabel.color
            }

            Label {
                id: homeLabel

                text: `${homeText} - ${projectText}`
                anchors.verticalCenter: parent.verticalCenter
                font.pointSize: 8
                color: "#41cd52"

                readonly property string homeText: "Home"
                readonly property string projectText: "Qt Base (Core, Gui, Widgets, Network, ...)"

                MouseArea {
                    anchors.fill: parent
                    onClicked: stackView.clearNavigation()
                }
            }
        }

        ListView {
            id: breadcrumb

            orientation: Qt.Horizontal
            height: 50
            clip: true
            focus: true
            z: homeRow.z - 1
            section.property: "modelData"
            section.criteria: ViewSection.FullString
            section.delegate: IconButton {
                text: MaterialIcons.mdiChevronDoubleLeft
                enabled: false
                hoverEnabled: false
                color: "#777"
                font.pointSize: 11
            }
            anchors {
                left: homeRow.right
                leftMargin: 20
                right: parent.right
                rightMargin: 5
                verticalCenter: parent.verticalCenter
            }
            model: ListModel {
                id: breadcrumbListModel
            }
            delegate: ItemDelegate {
                implicitHeight: 50
                implicitWidth: metrics.advanceWidth + 10

                Rectangle {
                    color: index === breadcrumb.currentIndex ? "#eea" : "transparent"
                    anchors.fill: parent
                }

                onClicked: {
                    console.log("navigate to dir...")
                    stackView.gotoNavigation(dirName)
                }

                TextMetrics {
                    id: metrics
                    text: label.text
                }

                Label {
                    id: label

                    text: dirName
                    font.pointSize: 8
                    color: homeLabel.color
                    anchors.centerIn: parent
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
            ScrollBar.vertical: ScrollBar {
                policy: ScrollBar.AsNeeded
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
                breadcrumb.incrementCurrentIndex()
            } else {
                breadcrumbListModel.remove({ dirName: dirName })
                breadcrumb.decrementCurrentIndex()
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
            signal clearNavigation
            signal gotoNavigation(var dirName)

            onOpenNavigation: function(dirName, args) {
                // show BusyIndicator
                openDirRunning()

                const item = push(gridViewComponent, args)

                // ignore initial and first item
                if (depth > 1) {
                    internal.currentDirs[dirName] = item
                    currentDirectoryChanged(dirName, false)
                }

                // start lazy hide BusyIndicator
                openDirFinished()
            }
            onBackNavigation: {
                if (depth > 1) {
                    const item = pop()
                    const dirName = Object.keys(internal.currentDirs).find(key => internal.currentDirs[key] === item)
                    delete internal.currentDirs[dirName]
                    currentDirectoryChanged(dirName, true)
                }
            }
            onClearNavigation: {
                // clear the stack
                while (depth > 1) {
                    stackView.pop()
                }

                // clear the breadcrumb itens map
                for (const key in internal.currentDirs) {
                    delete internal.currentDirs[key]
                }

                // clear the breadcrumb
                breadcrumbListModel.clear()
            }
            onGotoNavigation: function(dirName) {
                pop(internal.currentDirs[dirName])
            }

            pushEnter: Transition {
                PropertyAnimation {
                    property: "opacity"
                    from: 0
                    to:1
                    duration: 250
                }
            }
            pushExit: Transition {
                PropertyAnimation {
                    property: "opacity"
                    from: 1
                    to:0
                    duration: 250
                }
            }
            popEnter: Transition {
                PropertyAnimation {
                    property: "opacity"
                    from: 0
                    to:1
                    duration: 250
                }
            }
            popExit: Transition {
                PropertyAnimation {
                    property: "opacity"
                    from: 1
                    to:0
                    duration: 250
                }
            }

            QtObject {
                id: internal

                property var currentDirs: ({})
            }
        }

        Component.onCompleted: {
            const data = Backend.loadJson()
            stackView.openNavigation(data[0].name, {modelData: data, stackView: stackView})
        }
    }
}
