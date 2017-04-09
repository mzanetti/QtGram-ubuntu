import QtQuick 2.4
import QtQuick.Layouts 1.1
import Ubuntu.Components 1.3
import LibQTelegram 1.0

Rectangle {
    id: root

    property var context: null
    property bool active: false

    property var currentStickerSet: null

    signal stickerSelected(var sticker)

    ColumnLayout {
        id: column
        anchors { fill: parent; topMargin: units.gu(1) }
        spacing: 0

        ListView {
            id: stickerPacksView
            Layout.fillWidth: true
            orientation: ListView.Horizontal
            height: units.gu(5)
            spacing: units.gu(1)
            leftMargin: units.gu(1)
            rightMargin: units.gu(1)

            model: root.context.stickers

            delegate: StickerView {
                height: units.gu(4)
                width: height
                sticker: model.stickerPreview

                Component.onCompleted: if (index === 0) currentStickerSet = model.item

                delegate: Image {
                    anchors.fill: parent
                    source: "file://" + parent.source
                }

                AbstractButton {
                    anchors.fill: parent
                    onClicked: currentStickerSet = model.item
                }
            }
        }

        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: units.dp(1)
            color: UbuntuColors.lightGrey
        }
        GridView {
            id: gridView
            Layout.fillWidth: true
            Layout.fillHeight: true
            height: units.gu(20)
            clip: true
            topMargin: units.gu(1)
            model: StickerPackModel {
                id: stickerpackmodel
                telegram: context.telegram
                stickerSet: currentStickerSet
            }

            property real baseWidth: units.gu(10)
            property int maxItems: Math.floor(width / baseWidth)

            cellWidth: width / maxItems
            cellHeight: cellWidth

            delegate: StickerView {
                height: gridView.cellHeight
                width: gridView.cellWidth
                sticker: model.item

                delegate: Image {
                    anchors.fill: parent
                    source: "file://" + parent.thumbnail
                }

                AbstractButton {
                    anchors.fill: parent
                    onClicked: root.stickerSelected(model.item)
                }
            }
        }
    }
}
