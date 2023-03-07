//
//  UserCardView.swift
//  swifty
//
//  Created by Adrien Freire Eleuterio on 28/02/2023.
//

import SwiftUI
import Kingfisher

struct UserCardView: View {
    @Binding var color: String
    let imageUrl: URL
    let groups: [Groups]
    let title: String
    let place: String?
    let lastActivity: String
    let level: Double
    let state: BlackHoleState
    let timer: Int
    @Binding var showPicture: Bool
    let login: String

    var body: some View {
        ZStack {
            Color.gray
                .cornerRadius(15)
            VStack {
                HStack {
                    KFImage(imageUrl)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 150, height: 150)
                        .clipShape(Circle())
                        .onTapGesture {
                            withAnimation {
                                showPicture = true
                            }
                        }
                    Spacer()
                    VStack {
                        Spacer()
                        GroupsView(groups: groups)
                        Spacer()
                        Text(title)
                            .font(.title)
                            .bold()
                            .multilineTextAlignment(.center)
                        Spacer()
                        PlaceView(place: place, lastActivity: lastActivity)
                        Spacer()
                    }
                    Spacer()
                }
                LevelBar(level: level, color: $color)
                    .padding([.top, .trailing], 10)
                BlackHole(state: state, timer: timer)
            }
            .padding([.leading, .top, .bottom], 10)
        }
    }
}

struct GroupsView: View {
    let groups: [Groups]

    var body: some View {
        HStack {
            ForEach(groups, id: \.self) { group in
                Text("\(group.name.capitalized)")
            }
        }
    }
}

struct PlaceView: View {
    let place: String?
    let lastActivity: String

    var body: some View {
        if let place = place {
            Text(place)
                .font(.callout)
                .bold()
        } else {
            Text("Last seen:")
                .font(.callout)
                .bold()
            Text(lastActivity.timeAgoSinceDate())
                .font(.callout)
                .bold()
        }
    }
}

struct LevelBar: View {
    let level: Double
    @Binding var color: String

    var sizeProgressBar: CGFloat {
        return CGFloat(level.truncatingRemainder(dividingBy: 1))
        // getLevel > Double % 1 > CGFloat
    }

    var displayLevel: String {
        return "Level \(Int(level)) - \(Int(sizeProgressBar * 100))%"
        // "Level XX - XX%"
    }

    var body: some View {
        GeometryReader { proxy in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 20)
                    .foregroundColor(Color(hex: color).opacity(0.5))
                    .frame(width: proxy.size.width, height: 24)
                RoundedRectangle(cornerRadius: 20)
                    .foregroundColor(Color(hex: color))
                    .frame(width: proxy.size.width * sizeProgressBar, height: 24)
                Text(displayLevel)
                    .frame(width: proxy.size.width, height: 24)
            }
        }
        .frame(height: 24)
    }
}

struct BlackHole: View {
    let state: BlackHoleState
    let timer: Int

    var message: String? {
        switch state {
        case .learner:
            return nil
        case .blackhole:
            return "You've been absorbed by the Black Hole."
        case .member:
            return ""
        }
    }

    var body: some View {
        VStack {
            if let msg = message {
                if msg != "" {
                    Text(msg)
                        .multilineTextAlignment(.center)
                        .font(.system(size: 21))
                }
            } else {
                Text("Black Hole absorption")
                    .font(.system(size: 21))
                Text("\(timer) days left")
                    .bold()
                    .font(.system(size: 24))
            }
        }
    }
}
