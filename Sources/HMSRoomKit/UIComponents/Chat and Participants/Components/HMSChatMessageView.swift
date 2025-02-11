//
//  HMSChatMessageView.swift
//  HMSSDK
//
//  Created by Pawan Dixit on 16/08/2023.
//  Copyright © 2023 100ms. All rights reserved.
//

import SwiftUI
import HMSSDK
import Popovers
import HMSRoomModels

struct HMSChatMessageView: View {
    
    @EnvironmentObject var roomModel: HMSRoomModel
    @EnvironmentObject var theme: HMSUITheme
    
    let messageModel: HMSMessage
    var isPartOfTransparentChat: Bool
    @Binding var recipient: HMSRecipient?
    
    @State var isPopoverPresented = false
    
    var formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter
    }()
    
    var body: some View {
        if isPartOfTransparentChat {
            messageView
                .background(.backgroundDim, cornerRadius: 8, opacity: 0.64)
        }
        else {
            messageView
                .cornerRadius(8)
        }
    }
    
    var messageView: some View {
        HStack(alignment: .top, spacing: 12) {
            VStack(alignment: .leading, spacing: 8) {
                HStack(spacing: 4) {
                    Text(messageModel.sender?.name ?? "")
                        .font(.subtitle2Semibold14)
                        .foreground(.onSurfaceHigh)
//                        .foreground(isPartOfTransparentChat ? .white : .onSurfaceHigh)
//                        .shadow(color: isPartOfTransparentChat ? .black : .clear, radius: 3, y: 1)
                    
//                    if !isPartOfTransparentChat {
                        Text(formatter.string(from: messageModel.time))
                            .font(.captionRegular12).foreground(.onSurfaceMedium)
//                            .shadow(color: isPartOfTransparentChat ? .black : .clear, radius: 3, y: 1)
//                    }
                    
                    Spacer()
                    
                    HStack {
                        
                        if recipient == .everyone {
                            if messageModel.recipient.type == .peer {
                                Text("Direct Message")
                                    .lineLimit(1)
                                    .minimumScaleFactor(0.1)
                                    .font(.captionRegular12)
                                    .foreground(.onSecondaryHigh)
                                    .padding(4)
                                    .overlay {
                                        RoundedRectangle(cornerRadius: 4)
                                            .stroke()
                                            .foreground(.borderBright)
                                    }
                            }
                            else if messageModel.recipient.type == .roles {
                                HStack {
                                    Text("To Group")
                                        .foreground(.onSecondaryMedium)
                                    Text("\(messageModel.recipient.rolesRecipient?.first?.name ?? "")")
                                        .foreground(.onSecondaryHigh)
                                }
                                .font(.captionRegular12)
                                .lineLimit(1)
                                .minimumScaleFactor(0.1)
                                .padding(4)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 4)
                                        .stroke()
                                        .foreground(.borderBright)
                                }
                            }
                        }
                        
                        //                    if !isPartOfTransparentChat {
                        Button() {
                            UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                            DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(200)) {
                                isPopoverPresented.toggle()
                            }
                            
                        } label: {
                            Image(assetName: "vertical-ellipsis")
                                .resizable()
                                .frame(width: 3.33, height: 15)
                                .padding(.horizontal, 9)
                        }
                        .foreground(.onSurfaceLow)
                        .sheet(isPresented: $isPopoverPresented, content: {
                            HMSSheet {
                                HMSMessageOptionsView(messageModel: messageModel, recipient: $recipient)
                            }
                            .edgesIgnoringSafeArea(.all)
                            .environmentObject(theme)
                        })
                        //                    }
                    }
                }
                .padding(EdgeInsets(top: 2, leading: 0, bottom: 2, trailing: 0))
                .frame(maxWidth: .infinity)
                Text(LocalizedStringKey(messageModel.message))
                    .font(.body2Regular14)
                    .foreground(.onSurfaceHigh)
//                    .foreground(isPartOfTransparentChat ? .white : .onSurfaceHigh)
//                    .shadow(color: isPartOfTransparentChat ? .black : .clear ,radius: 3, y: 1)
                
            }
            .frame(maxWidth: .infinity)
            
        }
        .padding(12)
    }
}

struct HMSChatMessageView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
#if Preview
            HMSChatMessageView(messageModel: .init(message: "hello"), isPartOfTransparentChat: false, recipient: .constant(.everyone))
                .environmentObject(HMSUITheme())
                .environmentObject(HMSRoomModel.dummyRoom(3))
            
            HMSChatMessageView(messageModel: .init(message: "hello"), isPartOfTransparentChat: true, recipient: .constant(.everyone))
                .environmentObject(HMSUITheme())
                .environmentObject(HMSRoomModel.dummyRoom(3))
#endif
        }
    }
}
