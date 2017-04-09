import QtQuick 2.4
import Ubuntu.Components 1.3
import Ubuntu.PushNotifications 0.1

import "model"
import "js/Settings.js" as Settings

MainView {
    id: root
    applicationName: "qtgram.mzanetti"

    width: units.gu(90)
    height: units.gu(70)

    property var context: Context {
        telegram {
            onSignInRequested: apl.primaryPageSource = Qt.resolvedUrl("view/login/SignInView.qml")
            onSignUpRequested: apl.primaryPageSource = Qt.resolvedUrl("view/login/SignUpView.qml")
            onLoginCompleted: {
                apl.primaryPageSource = Qt.resolvedUrl("view/dialog/DialogsView.qml")
                pushClient.readyForPush = true;
                pushClient.registerForPush();
            }
        }
    }

    Component.onCompleted: {
        Settings.load(function(tx) {
            var phonenumber = Settings.transactionGet(tx, "phonenumber");

            if(phonenumber !== false) {
                context.telegram.initializer.phoneNumber = phonenumber;
                return
            }
            apl.primaryPageSource = Qt.resolvedUrl("view/login/PhoneNumberView.qml");
        });
    }

    AdaptivePageLayout {
        id: apl
        anchors.fill: parent

        Binding {
            target: apl.primaryPage
            property: "context"
            value: root.context
        }

        function connectIncubator(incubator, func) {

        }
    }

    PushClient {
        id: pushClient
        //appId: "com.ubuntu.telegram_telegram"// root.applicationName + "_QtGram-ubuntu"
        appId: root.applicationName + "_qtgram"

        property bool readyForPush: false
        property bool registered: false

        onNotificationsChanged: {
            print("PushClient notification:", notifications.length)
        }

        function registerForPush() {
            if (registered) return;

            if (!readyForPush) {
                console.warn("push - can't register, not logged-in yet.");
                return;
            }

            if (token.length === 0) {
                console.warn("push - can't register, empty token.");
                return;
            }

            console.log("push - registering with Telegram. Have Token", token);
            registered = true;
//            context.telegram.registerPush(token);
        }

        function unregisterFromPush() {
            console.log("push - unregistering from Telegram");
            pushUnregister(token);
            registered = false;
        }

        onTokenChanged: {
            console.log("push - token changed: " + (token.length > 0 ? "present" : "empty!"));
            if (token.length > 0) {
                registered = false;
                registerForPush();
            }
        }

        // onConnectedChanged: {
        //     if (token.length > 0) {
        //         registerForPush();
        //     }
        // }

        onError: {
            if (status == "bad auth") {
                console.warn("push - 'bad auth' error: " + status);
                if (Cutegram.promptForPush) {
                    push_dialog_loader.active = true;
                }
            } else {
                console.warn("push - unhandled error: " + status);
            }
        }
    }
}
