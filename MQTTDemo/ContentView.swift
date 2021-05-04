//
//  ContentView.swift
//  MQTTDemo
//
//  Created by Sun on 5/3/21.
//

import SwiftUI
import CocoaMQTT

struct ContentView: View {
    
    //State and printOut the state on console
    @State private var toggleState = false
    @State var payload: String
    
    let mqttClient = CocoaMQTT(clientID: "iPhone", host: mqttIp, port: mqttPort)
    
    var body: some View {
        VStack {
            Spacer()
            // This Text will be replace by a toggle
            HStack {
                Toggle("State", isOn: $toggleState)
                    .onChange(of: toggleState, perform: { value in
                        if toggleState {
                            mqttClient.publish("rpi/gpio", withString: "on")
                        } else {
                            mqttClient.publish("rpi/gpio", withString: "off")
                        }
                        print("State value is \(value)")
                    })
                    .toggleStyle(SwitchToggleStyle(tint: .red))
                
                toggleState ? Text("On") : Text("Off")

            }
            .padding()
            //Payload
            Text(payload)
            Spacer()
            
            //Connect button
            Button(action: {
                mqttClient.username=mqttId
                mqttClient.password=mqttPassword
                
                self.mqttClient.didConnectAck = { mqtt, ack in
                   self.mqttClient.subscribe("basement/Bed_Room")
                   self.mqttClient.didReceiveMessage = { mqtt, message, id in
                    self.payload = "Message received in topic \(message.topic) with payload \(message.string!)"
                   }
                }
                mqttClient.connect()
            }, label: {
                Text("Connect")
            })
            
            Spacer()
            
            //Disconnect button
            Button(action: {
                mqttClient.disconnect()
            }, label: {
                Text("Disconnect")
            })
            
            Spacer()
        }
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(payload: "Waiting ...")
    }
}
