import QtQuick
import QtQuick.Controls

import desafio_treinamento_qmob

ApplicationWindow {
    id: window
    width: 412
    height: 732
    visible: true
    title: qsTr("Desafio Treinamento Qmob | Enoque Santos")
    header: Rectangle {
        id: header

        height: 50
        color: "#41cd52"
        anchors {
            left: parent.left
            right: parent.right
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
                id: iconButton

                text: stackView.depth > 1 ? MaterialIcons.mdiChevronLeft : MaterialIcons.mdiHome
                anchors.verticalCenter: parent.verticalCenter
                enabled: stackView.depth > 1
                hoverEnabled: enabled
                onClicked: stackView.backNavigation()
                color: homeLabel.color
                background: Rectangle {
                    color: iconButton.down ? "#119900" : (iconButton.hovered ? "#22aa20" : "#41cd52")
                }
            }

            Label {
                id: homeLabel

                text: `${homeText} - ${projectText}`
                anchors.verticalCenter: parent.verticalCenter
                font.pointSize: 9
                color: "#fff"

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
            section.property: "dirName"
            section.labelPositioning: ViewSection.InlineLabels
            section.criteria: ViewSection.FullString
            section.delegate: IconButton {
                text: MaterialIcons.mdiChevronDoubleLeft
                enabled: false
                hoverEnabled: false
                color: "#22aa20"
                font.pointSize: 15
            }
            anchors {
                left: homeRow.right
                leftMargin: 10
                right: parent.right
                rightMargin: 5
                verticalCenter: parent.verticalCenter
            }
            model: ListModel {
                id: breadcrumbListModel
            }
            delegate: BreadCrumbDelegate { }
        }
    }

    //    Component.onCompleted: {
    //        var reply = Backend.http.get("https://qt.io")
    //        reply.onFinished.connect(function(response) {
    //            Backend.log("request response is:")
    //            Backend.log(response)
    //        })
    //    }

    property double cellWidth: width >= 800 ? width*0.18 : windth*35

    Component {
        id: gridViewComponent

        GridViewModel {
            cellWidth: cellWidth
            cellHeight: window.height*0.15
            Component.onCompleted: console.log("window.width: ", cellWidth)
        }
    }

    Connections {
        target: stackView

        function onDirChanged(dirUuid, dirName, isBackNavigation) {
            if (stackView.depth > 1) {
                homeLabel.text = homeLabel.homeText
            } else {
                homeLabel.text = `${homeLabel.homeText} - ${homeLabel.projectText}`
            }

            if (!isBackNavigation) {
                breadcrumbListModel.append({ dirUuid: dirUuid , dirName: dirName })
                breadcrumb.incrementCurrentIndex()
            } else {
                breadcrumbListModel.remove(breadcrumb.currentIndex, 1)
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
        color: "transparent"
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
            anchors.leftMargin: 5

            signal openDirRunning
            signal openDirFinished
            signal dirChanged(string dirUuid, string dirName, bool isBackNavigation)
            signal openNavigation(string dirUuid, string dirName, var _children)
            signal backNavigation
            signal clearNavigation
            signal gotoNavigation(string dirUuid)

            onOpenNavigation: function(dirUuid, dirName, _children) {
                // show BusyIndicator
                openDirRunning()

                const item = push(gridViewComponent, _children)

                // ignore initial and first item
                if (depth > 1) {
                    internal.dirs[dirUuid] = item
                    dirChanged(dirUuid, dirName, false)
                }

                // start lazy hide BusyIndicator
                openDirFinished()
            }
            onBackNavigation: {
                if (depth > 1) {
                    let dirUuid = breadcrumbListModel.get(breadcrumb.currentIndex).uuid

                    pop()

                    delete internal.dirs[dirUuid]
                    dirChanged(null, null, true)
                }
            }
            onClearNavigation: {
                // clear the stack
                while (depth > 1) {
                    stackView.pop()
                }

                // clear the breadcrumb itens map
                for (const key in internal.dirs) {
                    delete internal.dirs[key]
                }

                // clear the breadcrumb
                breadcrumbListModel.clear()
            }
            onGotoNavigation: function(dirUuid) {
                let gotoIndex = -1
                for (var i = 0; i < breadcrumbListModel.count; ++i) {
                    if (breadcrumbListModel.get(i).dirUuid === dirUuid) {
                        gotoIndex = i
                        breadcrumb.decrementCurrentIndex()
                        break
                    }
                }
                if (gotoIndex > -1) {
                    for (var j = breadcrumbListModel.count-1; j > gotoIndex; --j) {
                        breadcrumbListModel.remove(j, 1)
                    }
                }
                pop(internal.dirs[dirUuid])
            }

            pushEnter: Transition {
                PropertyAnimation {
                    property: "opacity"
                    from: 0
                    to:1
                    duration: 150
                }
            }
            pushExit: Transition {
                PropertyAnimation {
                    property: "opacity"
                    from: 1
                    to:0
                    duration: 150
                }
            }
            popEnter: Transition {
                PropertyAnimation {
                    property: "opacity"
                    from: 0
                    to:1
                    duration: 200
                }
            }
            popExit: Transition {
                PropertyAnimation {
                    property: "opacity"
                    from: 1
                    to:0
                    duration: 200
                }
            }

            QtObject {
                id: internal

                property var dirs: ({})
            }
        }

        Component.onCompleted: {
            const data = Backend.loadJson()
            stackView.openNavigation(data[0].uuid, data[0].name, {modelData: data, stackView: stackView})
        }
    }
}
