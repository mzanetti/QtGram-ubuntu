import QtQuick 2.4
import Ubuntu.Components 1.3
import QtQuick.Layouts 1.1

Page {
    id: root

    property var context: null

    header: PageHeader {
        title: "Confirm login"
    }

    Timer
    {
        id: timdisablebutton
        running: false
        interval: 2000
    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: units.gu(2)
        anchors.topMargin: root.header.height + units.gu(2)
        spacing: units.gu(2)

        Label {
            text: "Wait for the SMS containing the activation code and press 'Sign In'"
            Layout.fillWidth: true
            wrapMode: Text.WordWrap
        }

        TextField {
            id: tfcode
            focus: true
            Layout.fillWidth: true
            placeholderText: "Code"
            inputMethodHints: Qt.ImhDigitsOnly
        }

        Button {
            id: btnsignin
            Layout.fillWidth: true
            text: qsTr("Sign In")
            enabled: tfcode.text.length > 0
            color: UbuntuColors.green

            onClicked: {
                btnsignin.enabled = false;
                btnsignin.text = qsTr("Sending request...");
                context.telegram.signIn(tfcode.text);
            }
        }

        Button {
            id: btnresendcode
            anchors.horizontalCenter: parent.horizontalCenter
            enabled: !timdisablebutton.running
            Layout.fillWidth: true
            color: UbuntuColors.orange

            text: timdisablebutton.running ? qsTr("Requesting new code...") : qsTr("Resend code")

            onClicked: {
                timdisablebutton.start();
                context.telegram.resendCode();
            }
        }
        Item {
            Layout.fillWidth: true
            Layout.fillHeight: true
        }

    }
}
