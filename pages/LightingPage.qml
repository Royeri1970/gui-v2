import QtQuick
import Victron.VenusOS

SwipeViewPage {
    id: root

    title: "Belysning"
    iconSource: "qrc:/images/icon_switch_24.svg"
    url: "qrc:/qt/qml/Victron/VenusOS/pages/LightingPage.qml"
    topLeftButton: VenusOS.StatusBar_LeftButton_ControlsInactive

    property SwitchableOutput rgbOutput: null

    // Finn RGB-lyset i Belysning-gruppen
    Repeater {
        model: SortedIOChannelGroupModel {
            sourceModel: Global.switches.groups
        }

        delegate: Item {
            required property IOChannelGroup group
            visible: false

            Repeater {
                model: group.name === "Belysning" ? group.channels : []

                delegate: Item {
                    required property IOChannel modelData
                    visible: false

                    Component.onCompleted: {
                        if (modelData.type ===
                                VenusOS.SwitchableOutput_Type_ColorDimmerRgb
                                && modelData.formattedName.indexOf("Markiselys") !== -1) {
                            root.rgbOutput = modelData
                        }
                    }

                    Component.onDestruction: {
                        if (root.rgbOutput === modelData)
                            root.rgbOutput = null
                    }
                }
            }
        }
    }

    Loader {
        anchors.centerIn: parent
        active: root.rgbOutput !== null

        sourceComponent: Item {
            width: 790
            height: 390

            ColorDimmerData {
                id: rgbData
                dataUid: root.rgbOutput.uid + "/LightControls"
                outputType: root.rgbOutput.type
            }

            Row {
                anchors.centerIn: parent
                spacing: 20

                // Venstre panel
                Rectangle {
                    width: 410
                    height: 360
                    radius: 16
                    color: Theme.color_background_secondary

                    Column {
                        anchors.centerIn: parent
                        width: 375
                        spacing: 18

                        Label {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: "Markiselys"
                            color: Theme.color_font_primary
                            font.pixelSize: 26
                        }

                        // Av/på og dimmer uten ekstra fargevindu
                        SwitchableOutputDimmableSlider {
                            width: parent.width
                            height: 70
                            switchableOutput: root.rgbOutput
                            from: 0
                            to: 1
                            stepSize: 0.01

                            valueDataItem: QtObject {
                                readonly property real value: rgbData.color.hsvValue

                                function setValue(v) {
                                    rgbData.color.hsvValue = v
                                    rgbData.save()
                                }
                            }
                        }

                        Label {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: Math.round(rgbData.color.hsvValue * 100) + " %"
                            color: Theme.color_font_primary
                            font.pixelSize: 24
                        }

                        Label {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: "Hurtigfarger"
                            color: Theme.color_font_secondary
                            font.pixelSize: 19
                        }

                        Row {
                            anchors.horizontalCenter: parent.horizontalCenter
                            spacing: 10

                            Repeater {
                                model: [
                                    { name: "Rød", hue: 0, sat: 1, color: "#ff3333" },
                                    { name: "Gul", hue: 0.167, sat: 1, color: "#ffff33" },
                                    { name: "Grønn", hue: 0.333, sat: 1, color: "#33dd66" },
                                    { name: "Blå", hue: 0.667, sat: 1, color: "#3388ff" },
                                    { name: "Lilla", hue: 0.778, sat: 1, color: "#bb55ff" },
                                    { name: "Hvit", hue: 0, sat: 0, color: "#ffffff" }
                                ]

                                delegate: Rectangle {
                                    required property var modelData

                                    width: 47
                                    height: 47
                                    radius: 12
                                    color: modelData.color
                                    border.color: "#aab8ce"
                                    border.width: 1

                                    MouseArea {
                                        anchors.fill: parent

                                        onClicked: {
                                            var brightness = Math.max(
                                                0.1, rgbData.color.hsvValue)
                                            rgbData.color = Qt.hsva(
                                                modelData.hue,
                                                modelData.sat,
                                                brightness,
                                                1)
                                            rgbData.save()
                                            colorSelector.updateWheelAngle()
                                        }
                                    }
                                }
                            }
                        }
                    }
                }

                // Høyre panel – permanent fargehjul
                Rectangle {
                    width: 360
                    height: 390
                    radius: 16
                    color: Theme.color_background_secondary

                    Column {
                        anchors.centerIn: parent
                        spacing: 12

                        Label {
                            anchors.horizontalCenter: parent.horizontalCenter
                            text: "Velg lysfarge"
                            color: Theme.color_font_primary
                            font.pixelSize: 24
                        }

                        ColorSelector {
                            id: colorSelector
                            anchors.horizontalCenter: parent.horizontalCenter
                            colorDimmerData: rgbData
                            outputType: root.rgbOutput.type
                        }
                    }
                }
            }
        }
    }
}
