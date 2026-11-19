import QtQuick
import Victron.VenusOS

SwipeViewPage {
    id: root
    title: "MultiPlus-II"
    iconSource: "qrc:/images/inverter_charger.svg"
    url: "qrc:/qt/qml/Victron/VenusOS/pages/MultiPlusPage.qml"
    topLeftButton: VenusOS.StatusBar_LeftButton_ControlsInactive

    readonly property string vebusUid: BackendConnection.serviceUidFromName(
        "com.victronenergy.vebus.ttyS4", 276)

    function numberText(item, digits, unit) {
        return item.valid && item.value !== null && item.value !== undefined
                && !isNaN(Number(item.value))
                ? Number(item.value).toFixed(digits) + " " + unit : "–"
    }

    VeQuickItem { id: mainsLed; uid: root.vebusUid + "/Leds/Mains" }
    VeQuickItem { id: inverterLed; uid: root.vebusUid + "/Leds/Inverter" }
    VeQuickItem { id: bulkLed; uid: root.vebusUid + "/Leds/Bulk" }
    VeQuickItem { id: absorptionLed; uid: root.vebusUid + "/Leds/Absorption" }
    VeQuickItem { id: floatLed; uid: root.vebusUid + "/Leds/Float" }
    VeQuickItem { id: overloadLed; uid: root.vebusUid + "/Leds/Overload" }
    VeQuickItem { id: lowBatteryLed; uid: root.vebusUid + "/Leds/LowBattery" }
    VeQuickItem { id: temperatureLed; uid: root.vebusUid + "/Leds/Temperature" }

    VeQuickItem { id: acInput; uid: root.vebusUid + "/Ac/ActiveIn/L1/V" }
    VeQuickItem { id: acInputCurrent; uid: root.vebusUid + "/Ac/ActiveIn/L1/I" }
    VeQuickItem { id: acOutput; uid: root.vebusUid + "/Ac/Out/L1/V" }
    VeQuickItem { id: batteryVoltage; uid: root.vebusUid + "/Dc/0/Voltage" }
    VeQuickItem { id: batteryCurrent; uid: root.vebusUid + "/Dc/0/Current" }
    VeQuickItem { id: acPower; uid: root.vebusUid + "/Ac/Out/L1/P" }
    VeQuickItem { id: acConnected; uid: root.vebusUid + "/Ac/ActiveIn/Connected" }

    readonly property string chargeState: floatLed.valid && Number(floatLed.value) > 0 ? "Float"
        : absorptionLed.valid && Number(absorptionLed.value) > 0 ? "Absorption"
        : bulkLed.valid && Number(bulkLed.value) > 0 ? "Bulk"
        : inverterLed.valid && Number(inverterLed.value) > 0 ? "Inverter"
        : "Standby"

    Rectangle {
        anchors.fill: parent
        color: "#08192b"

        Flickable {
            id: scroller
            anchors.fill: parent
            clip: true
            boundsBehavior: Flickable.StopAtBounds
            contentWidth: Math.max(width, 810)
            contentHeight: 424

            Item {
                width: scroller.contentWidth
                height: 424

                Text {
                    x: 16; y: 10
                    text: "MultiPlus-II 12/4000/160-32"
                    color: "#f5f9ff"
                    font.pixelSize: 24
                    font.bold: true
                }
                Text {
                    anchors.right: parent.right
                    anchors.rightMargin: 18
                    y: 18
                    text: root.chargeState + "  •  VE.Bus"
                    color: "#41d7a0"
                    font.pixelSize: 14
                    font.bold: true
                }

                // Three horizontal columns; no tall cards pushed under the navigation bar.
                Row {
                    id: dashboard
                    x: 14; y: 52
                    width: parent.width - 28
                    height: 334
                    spacing: 12

                     // Frontmotiv: blå MultiPlus-II med sorte hjørnebeskyttere.
                     // Tegnet i QML for lokal GX og WebAssembly, uten ekstra bildefil.
                     Rectangle {
                         id: devicePanel
                         width: Math.round((dashboard.width - 24) * 0.27)
                         height: parent.height
                         radius: 12
                         color: "#12273d"
                         border.color: "#327bb4"
                         border.width: 1

                         Rectangle {
                             id: multipIusCase
                             x: 23
                             y: 9
                             width: parent.width - 46
                             height: parent.height - 18
                             radius: 5
                             color: "#126fbd"
                             border.color: "#55afe0"
                             border.width: 1

                             // Lysrefleks på metallfronten.
                             Rectangle {
                                 x: 3; y: 3
                                 width: parent.width - 6; height: parent.height - 6
                                 radius: 3
                                 gradient: Gradient {
                                     GradientStop { position: 0.0; color: "#258be0" }
                                     GradientStop { position: 0.35; color: "#126fbd" }
                                     GradientStop { position: 1.0; color: "#07538f" }
                                 }
                             }
                             // Orange skillebånd som på MultiPlus-II-fronten.
                             Rectangle {
                                 x: 3; y: 98
                                 width: parent.width - 6; height: 17
                                 color: "#fa7818"
                             }
                             Text {
                                 x: 14; y: 37
                                 text: "victron energy"
                                 color: "#ffffff"
                                 font.pixelSize: 15
                                 font.bold: true
                             }
                             Text {
                                 x: 14; y: 144
                                 text: "MultiPlus-II"
                                 color: "#ffffff"
                                 font.pixelSize: 20
                                 font.bold: true
                             }
                             Text {
                                 x: 14; y: 173
                                 text: "12/4000/160-32"
                                 color: "#e5f4ff"
                                 font.pixelSize: 12
                             }
                             // Diskré statusmerking på den fysiske enheten.
                             Rectangle {
                                 x: 14; y: 215
                                 width: 89; height: 53
                                 radius: 4
                                 color: "#0d3356"
                                 border.color: "#2c5e83"
                                 Column {
                                     x: 8; y: 6
                                     spacing: 3
                                     Repeater {
                                         model: ["inverter", "charger", "alarm"]
                                         delegate: Row {
                                             spacing: 5
                                             Rectangle {
                                                 width: 7; height: 7; radius: 4
                                                 color: index === 2 ? "#d65f43" : "#36d96b"
                                             }
                                             Text {
                                                 text: modelData
                                                 color: "#e6f4ff"
                                                 font.pixelSize: 9
                                             }
                                         }
                                     }
                                 }
                             }
                             // Ventilasjonsgrill nederst.
                             Rectangle {
                                 x: 3; y: parent.height - 32
                                 width: parent.width - 6; height: 28
                                 color: "#09283d"
                                 Repeater {
                                     model: 14
                                     Rectangle {
                                         x: 7 + index * ((parent.width - 14) / 14)
                                         y: 7
                                         width: 5; height: 12
                                         radius: 1
                                         color: "#28516c"
                                     }
                                 }
                             }
                         }
                         // Fire sorte gummihjørner på kabinettet.
                         Repeater {
                             model: 4
                             Rectangle {
                                 width: 35
                                 height: 27
                                 radius: 4
                                 x: index % 2 === 0 ? 13 : devicePanel.width - width - 13
                                 y: index < 2 ? 4 : devicePanel.height - height - 4
                                 gradient: Gradient {
                                     GradientStop { position: 0.0; color: "#343b43" }
                                     GradientStop { position: 1.0; color: "#151c24" }
                                 }
                             }
                         }
                     }
                    // Live VE.Bus indicator panel.
                    Rectangle {
                        id: ledsPanel
                        width: Math.round((dashboard.width - 24) * 0.31)
                        height: parent.height
                        radius: 12
                        color: "#0e253c"
                        border.color: "#327bb4"
                        border.width: 1

                        Text {
                            x: 14; y: 14
                            text: "STATUS (LED)"
                            color: "#eef7ff"
                            font.pixelSize: 18
                            font.bold: true
                        }
                        Rectangle {
                            x: 14; y: 43
                            width: parent.width - 28
                            height: 1
                            color: "#325e83"
                        }
                        Column {
                            x: 14; y: 54
                            width: parent.width - 28
                            spacing: 2
                            Repeater {
                                model: [
                                    { label: "Mains on", path: "Mains", tint: "#39ed77" },
                                    { label: "Inverter on", path: "Inverter", tint: "#39ed77" },
                                    { label: "Bulk", path: "Bulk", tint: "#ffcf45" },
                                    { label: "Absorption", path: "Absorption", tint: "#ffcf45" },
                                    { label: "Float", path: "Float", tint: "#ffcf45" },
                                    { label: "Overload", path: "Overload", tint: "#ff6666" },
                                    { label: "Low battery", path: "LowBattery", tint: "#ff6666" },
                                    { label: "Temperature", path: "Temperature", tint: "#ff6666" }
                                ]
                                delegate: Item {
                                    width: ledsPanel.width - 28
                                    height: 32
                                    VeQuickItem {
                                        id: ledStatus
                                        uid: root.vebusUid + "/Leds/" + modelData.path
                                    }
                                    Rectangle {
                                        id: ledLamp
                                        x: 5; y: 7
                                        width: 17; height: 17
                                        radius: 9
                                        color: ledStatus.valid && Number(ledStatus.value) > 0
                                               ? modelData.tint : "#52677a"
                                        border.color: ledStatus.valid && Number(ledStatus.value) > 0
                                                      ? "#eaffff" : "#8094a8"
                                        border.width: 1
                                    }
                                    Text {
                                        x: 34
                                        anchors.verticalCenter: parent.verticalCenter
                                        width: parent.width - 36
                                        text: modelData.label
                                        color: "#f1f7fd"
                                        elide: Text.ElideRight
                                        font.pixelSize: 14
                                    }
                                }
                            }
                        }
                    }

                    // Six compact readings, all visible without vertical scrolling.
                    Rectangle {
                        id: valuesPanel
                        width: dashboard.width - devicePanel.width - ledsPanel.width - 24
                        height: parent.height
                        radius: 12
                        color: "#0e253c"
                        border.color: "#327bb4"
                        border.width: 1

                        Text {
                            x: 14; y: 14
                            text: "MÅLEVERDIER"
                            color: "#eef7ff"
                            font.pixelSize: 18
                            font.bold: true
                        }
                        Rectangle {
                            x: 14; y: 43
                            width: parent.width - 28
                            height: 1
                            color: "#325e83"
                        }
                        Column {
                            x: 14; y: 52
                            width: parent.width - 28
                            spacing: 4
                            Repeater {
                                model: [
                                    { label: "AC inn (landstrøm)", val: root.numberText(acInput, 0, "V") },
                                    { label: "AC inngangsstrøm", val: root.numberText(acInputCurrent, 1, "A") },
                                    { label: "AC ut", val: root.numberText(acOutput, 0, "V") },
                                    { label: "Batterispenning", val: root.numberText(batteryVoltage, 1, "V") },
                                    { label: "Batteristrøm", val: root.numberText(batteryCurrent, 1, "A") },
                                    { label: "AC ut-effekt", val: root.numberText(acPower, 0, "W") }
                                ]
                                delegate: Rectangle {
                                    width: valuesPanel.width - 28
                                    height: 39
                                    radius: 6
                                    color: index % 2 === 0 ? "#163756" : "#112b46"
                                    Text {
                                        x: 9
                                        anchors.verticalCenter: parent.verticalCenter
                                        width: parent.width * 0.57
                                        text: modelData.label
                                        color: "#b8d7f3"
                                        font.pixelSize: 12
                                        elide: Text.ElideRight
                                    }
                                    Text {
                                        anchors.right: parent.right
                                        anchors.rightMargin: 9
                                        anchors.verticalCenter: parent.verticalCenter
                                        text: modelData.val
                                        color: "#ffffff"
                                        font.bold: true
                                        font.pixelSize: 16
                                    }
                                }
                            }
                        }
                        Text {
                            x: 14; y: parent.height - 26
                            width: parent.width - 28
                            text: acConnected.valid
                                  ? (Number(acConnected.value) ? "● Landstrøm tilkoblet" : "○ Landstrøm frakoblet")
                                  : "Landstrøm: –"
                            font.pixelSize: 12
                            color: acConnected.valid && Number(acConnected.value) ? "#42d99a" : "#a8bed3"
                        }
                    }
                }
            }
        }
    }
}
