import QtQuick
import Victron.VenusOS

SwipeViewPage {
    id: root
    title: "MultiPlus-II"
    iconSource: "qrc:/images/inverter_charger.svg"
    url: "qrc:/qt/qml/Victron/VenusOS/pages/MultiPlusPage.qml"
    topLeftButton: VenusOS.StatusBar_LeftButton_ControlsInactive

    // This is the confirmed VE.Bus service and DeviceInstance on this Cerbo GX.
    readonly property string vebusUid: BackendConnection.serviceUidFromName(
        "com.victronenergy.vebus.ttyS4", 276)

    function numberText(item, digits, unit) {
        return item.valid && item.value !== null && item.value !== undefined
                && !isNaN(Number(item.value))
                ? Number(item.value).toFixed(digits) + " " + unit : "–"
    }

    VeQuickItem { id: acInput; uid: root.vebusUid + "/Ac/ActiveIn/L1/V" }
    VeQuickItem { id: acOutput; uid: root.vebusUid + "/Ac/Out/L1/V" }
    VeQuickItem { id: batteryVoltage; uid: root.vebusUid + "/Dc/0/Voltage" }
    VeQuickItem { id: batteryCurrent; uid: root.vebusUid + "/Dc/0/Current" }
    VeQuickItem { id: acPower; uid: root.vebusUid + "/Ac/Out/L1/P" }
    VeQuickItem { id: acConnected; uid: root.vebusUid + "/Ac/ActiveIn/Connected" }

    Rectangle {
        anchors.fill: parent
        color: "#0a1424"

        Flickable {
            id: scroller
            anchors.fill: parent
            contentWidth: width
            contentHeight: mainColumn.height + 40
            boundsBehavior: Flickable.StopAtBounds
            clip: true

            Column {
                id: mainColumn
                x: 18
                y: 18
                width: scroller.width - 36
                spacing: 14

                Text {
                    width: parent.width
                    text: "MultiPlus-II 12/4000/160-32"
                    font.pixelSize: 25
                    font.bold: true
                    color: "#f5f9ff"
                    wrapMode: Text.WordWrap
                }
                Text {
                    text: "VE.Bus  •  LIVE STATUS"
                    color: "#89bce8"
                    font.pixelSize: 12
                    font.letterSpacing: 1
                }

                // Main blue faceplate. Everything is QML: no external image assets.
                Rectangle {
                    width: parent.width
                    height: mainColumn.width < 630 ? 530 : 342
                    radius: 15
                    color: "#10345f"
                    border.color: "#3783c2"
                    border.width: 2

                    Rectangle {
                        x: 2; y: 2
                        width: parent.width - 4; height: 45
                        radius: 12
                        color: "#194d80"
                    }
                    Text {
                        x: 18; y: 12
                        text: "victron energy"
                        font.pixelSize: 20
                        font.bold: true
                        color: "#ffffff"
                    }
                    Text {
                        x: 18; y: 53
                        text: "MultiPlus-II"
                        font.pixelSize: 23
                        font.bold: true
                        color: "#f5faff"
                    }
                    Text {
                        x: 18; y: 82
                        text: "12/4000/160-32"
                        font.pixelSize: 13
                        color: "#b4d5f0"
                    }

                    // Stylized physical MultiPlus casing.
                    Rectangle {
                        id: unitBody
                        x: 18
                        y: 112
                        width: parent.width < 630 ? parent.width - 36 : parent.width * 0.42
                        height: parent.width < 630 ? 143 : 200
                        radius: 9
                        color: "#e4e9ed"
                        border.color: "#99acbe"
                        border.width: 2
                        Rectangle {
                            x: 8; y: 8
                            width: parent.width - 16; height: 35
                            color: "#20629b"
                            radius: 3
                            Text {
                                anchors.centerIn: parent
                                text: "victron energy"
                                color: "white"
                                font.pixelSize: 16
                                font.bold: true
                            }
                        }
                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            y: 59
                            text: "MultiPlus-II"
                            color: "#294866"
                            font.bold: true
                            font.pixelSize: 19
                        }
                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            y: 86
                            text: "12/4000/160-32"
                            color: "#4c6680"
                            font.pixelSize: 12
                        }
                        Rectangle {
                            x: 14; y: parent.height - 22
                            width: parent.width - 28; height: 7
                            radius: 3
                            color: "#b4bec8"
                        }
                    }

                    Text {
                        id: ledTitle
                        x: parent.width < 630 ? 20 : unitBody.x + unitBody.width + 24
                        y: parent.width < 630 ? 266 : 107
                        text: "STATUSINDIKATORER"
                        color: "#b7dcfa"
                        font.pixelSize: 13
                        font.bold: true
                    }

                    Grid {
                        id: ledGrid
                        x: ledTitle.x
                        y: ledTitle.y + 28
                        width: parent.width < 630 ? parent.width - 40 : parent.width - x - 18
                        columns: 2
                        columnSpacing: 8
                        rowSpacing: 12
                        Repeater {
                            model: [
                                { label: "Mains on", path: "Mains", tint: "#44e67b" },
                                { label: "Inverter on", path: "Inverter", tint: "#44e67b" },
                                { label: "Bulk", path: "Bulk", tint: "#f6c44c" },
                                { label: "Overload", path: "Overload", tint: "#f26969" },
                                { label: "Absorption", path: "Absorption", tint: "#f6c44c" },
                                { label: "Low battery", path: "LowBattery", tint: "#f26969" },
                                { label: "Float", path: "Float", tint: "#f6c44c" },
                                { label: "Temperature", path: "Temperature", tint: "#f26969" }
                            ]
                            delegate: Item {
                                width: (ledGrid.width - ledGrid.columnSpacing) / 2
                                height: 29
                                VeQuickItem {
                                    id: ledStatus
                                    uid: root.vebusUid + "/Leds/" + modelData.path
                                }
                                Rectangle {
                                    id: ledLamp
                                    width: 16
                                    height: 16
                                    radius: 8
                                    anchors.left: parent.left
                                    anchors.verticalCenter: parent.verticalCenter
                                    color: ledStatus.valid && Number(ledStatus.value) > 0
                                           ? modelData.tint : "#334b65"
                                    border.color: ledStatus.valid && Number(ledStatus.value) > 0
                                                  ? "#f4fcff" : "#6884a2"
                                }
                                Text {
                                    x: ledLamp.width + 7
                                    anchors.verticalCenter: parent.verticalCenter
                                    width: parent.width - x
                                    text: modelData.label
                                    color: "#f0f6fc"
                                    font.pixelSize: 13
                                    elide: Text.ElideRight
                                }
                            }
                        }
                    }
                }

                Rectangle {
                    width: parent.width
                    height: 232
                    radius: 15
                    color: "#112842"
                    border.color: "#2c6094"
                    border.width: 1
                    Text {
                        x: 16; y: 14
                        text: "MÅLEVERDIER"
                        font.pixelSize: 14
                        font.bold: true
                        color: "#a5cff3"
                    }
                    Grid {
                        id: valueGrid
                        x: 16; y: 47
                        width: parent.width - 32
                        columns: 2
                        columnSpacing: 16
                        rowSpacing: 14
                        Repeater {
                            model: [
                                { caption: "AC INN", valueText: root.numberText(acInput, 0, "V") },
                                { caption: "AC UT", valueText: root.numberText(acOutput, 0, "V") },
                                { caption: "BATTERISPENNING", valueText: root.numberText(batteryVoltage, 1, "V") },
                                { caption: "BATTERISTRØM", valueText: root.numberText(batteryCurrent, 1, "A") },
                                { caption: "AC UT-EFFEKT", valueText: root.numberText(acPower, 0, "W") },
                                { caption: "LANDSTRØM", valueText: acConnected.valid ? (Number(acConnected.value) ? "Tilkoblet" : "Frakoblet") : "–" }
                            ]
                            delegate: Column {
                                width: (valueGrid.width - valueGrid.columnSpacing) / 2
                                spacing: 3
                                Text {
                                    text: modelData.caption
                                    color: "#a2bed9"
                                    font.pixelSize: 11
                                }
                                Text {
                                    text: modelData.valueText
                                    color: "#f8fbff"
                                    font.bold: true
                                    font.pixelSize: 19
                                }
                            }
                        }
                    }
                }

                Text {
                    width: parent.width
                    text: "Status og måleverdier leses direkte fra MultiPlus-II via VE.Bus."
                    color: "#9eb5cd"
                    font.pixelSize: 12
                    wrapMode: Text.WordWrap
                }
            }
        }
    }
}
