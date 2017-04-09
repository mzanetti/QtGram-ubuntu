import QtQuick 2.4

Image
{
    id: stickermessage
    source: "file://" + (mediamessageitem.downloaded ? mediamessageitem.source : mediamessageitem.thumbnail)
    Component.onCompleted: {
        if (!mediamessageitem.downloaded) {
            mediamessageitem.download();
        }
    }
}
