//
//  ChatView.swift
//  FireChat
//
//  Created by Mubeen Asif on 25/10/2024.
//

import SwiftUI

struct ChatView: View {
    
    // TODO: Access authManager from the environment
    @Environment(AuthManager.self) var authManager
    
    @State var messageManager: MessageManager
    
    init(isMocked: Bool = false) {
        messageManager = MessageManager(isMocked: isMocked)
    }
    
    var body: some View {
        NavigationStack {
            Text("Welcome to FireChat!")
                .navigationTitle("Chat")
                .navigationBarTitleDisplayMode(.inline)
                .toolbar {
                    ToolbarItem {
                        Button("Sign out") {
                            authManager.signOut()
                        }
                    }
                }
            
            ScrollView { // <-- Add ScrollView
                VStack { // <-- Add VStack
                    ForEach(messageManager.messages) { message in
                        MessageRow(text: message.text, isOutgoing: authManager.userEmail == message.username)
                    }
                }
            }.defaultScrollAnchor(.bottom)
                .safeAreaInset(edge: .bottom) { // <-- Add safeAreaInset modifier to add and display send message view above the bottom safe area
                    SendMessageView { messageText in
                        // TODO: Save message to Firestore
                        messageManager.sendMessage(text: messageText, username: authManager.userEmail ?? "")
                    }
                }
        }
        
    }
}

#Preview {
    ChatView(isMocked: true) // <-- Pass in true to isMocked to use the mocked version of the message manager in the preview
        .environment(AuthManager())
}
