import QtQuick 2.7
import QtQuick.Controls 2.0
import QtQuick.Layouts 1.3
import QSyncable 1.0
import SortFilterProxyModel 0.2
import QtLocation 5.3
import QtPositioning 5.6

ApplicationWindow {
    id: window
    visible: true
    width: 800
    height: 480
    title: qsTr("Meetup Qt Nantes")

    JsonListModel {
        id: biclouModel
        keyField: "number"
    }

    SortFilterProxyModel {
        id: biclouProxyModel
        sourceModel: biclouModel
    }

    RowLayout {
        anchors.fill: parent

        Pane {
            Layout.preferredWidth: parent.width / 4
            Layout.fillHeight: true
            padding: 0
            ListView {
                anchors.fill: parent
                model: biclouProxyModel
                delegate: ItemDelegate {
                    width: parent.width
                    text: model.name + " (" + model.available_bikes + "/" + model.bike_stands + ")"
                }
            }
        }

        Map {
            Layout.fillWidth: true
            Layout.fillHeight: true
            plugin: Plugin { name: "esri" }
            center: QtPositioning.coordinate(47.2179751, -1.5615788) // Nantes
            zoomLevel: 14

            MapItemView {
                model: biclouProxyModel
                delegate: MapQuickItem {
                    coordinate: QtPositioning.coordinate(position.lat, position.lng)
                    anchorPoint: Qt.point(10, 10)
                    sourceItem: Rectangle {
                        color: "orange"
                        width: 20
                        radius: width/2
                        height: width
                        Text {
                            id: availableBikesLabel
                            color: "white"
                            anchors.fill: parent
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            text: available_bikes
                            Behavior on text {
                                FadeAnimation { fadeDuration: 500; target: availableBikesLabel }
                            }
                            onTextChanged: print(name, text)
                        }
                    }
                }
            }
        }

        Timer {
            running: true
            interval: 5000
            triggeredOnStart: true
            repeat: true
            onTriggered: {
                var xhr = new XMLHttpRequest();
                xhr.onreadystatechange = function() {
                    if (xhr.readyState === XMLHttpRequest.DONE && xhr.status === 200)
                        biclouModel.source = JSON.parse(xhr.responseText);
                };

                xhr.open("GET", "https://api.jcdecaux.com/vls/v1/stations?contract=Nantes&apiKey=" + jcdecaux_api_key);
                xhr.send();
            }
        }
    }
}
