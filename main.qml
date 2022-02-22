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

    header: Row {
        id: header

        height: 50
        anchors {
            left: parent.left
            leftMargin: 5
            right: parent.right
            rightMargin: 5
        }

        IconButton {
            id: upButton

            text: stackView.depth > 1 ? MaterialIcons.mdiChevronUp : MaterialIcons.mdiHome
            anchors.verticalCenter: parent.verticalCenter
            onClicked: {
                if (stackView.depth > 1)
                    stackView.pop()
            }
        }

        Label {
            text: "Home"
            anchors.verticalCenter: parent.verticalCenter
        }

        ListView {
            id: breadcrumb

            orientation: Qt.Horizontal
            model: ListModel {
                id: breadcrumbListModel
            }
            delegate: ItemDelegate {
                Row {
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

            cellWidth: window.width*0.25
            cellHeight: window.height*0.12
            model: ListModel {
                id: gridViewModel
            }
            delegate: FolderItemDelegate {
                width: gridView.cellWidth
                height: gridView.cellHeight
                onOpenDir: function(dirs) {
                    var args = {
                        modelData: dirs,
                        stackView: stackView
                    }
                    stackView.push(gridViewComponent, args)
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

    Rectangle {
        anchors.fill: parent
        color: "#ddd"

        StackView {
            id: stackView

            anchors.fill: parent
        }

        Component.onCompleted: {
            let data = Backend.loadJson()
            if (!Array.isArray(data)) {
                data = [data]
            }

            stackView.push(gridViewComponent, {modelData: data, stackView: stackView})
        }
    }
}
