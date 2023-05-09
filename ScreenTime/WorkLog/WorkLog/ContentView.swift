//
//  ContentView.swift
//  Worklog
//
//  Created by 김영빈 on 2023/04/26.
//

/*
 - FamilyControls 프레임워크에는 작업을 위한 SwiftUI 요소인 familyActivityPicker가 있다.
 - 기본 앱의 UI에서 이 피커를 표시하고, 앱 or 웹을 카테고리 목록에서 선택한다.
 - 버튼을 통해 불러온 피커는 반환값을 모델의 속성에 바인딩한다.($model.selectionToDiscourage)
   - selection에 지정된 모델의 선택 값 프로퍼티는 피커로 선택한 값이 변경될 때마다 갱신됨
 - 앱을 선택한 뒤에는 familyActivityPicker에서 반환된 토큰을 사용할 수 있음.
   - 이 토큰은 각각의 앱과 웹사이트 등을 나타내며, 토큰을 통해 해당하는 앱 등에 제한을 적용해준다.
*/
import SwiftUI
import FamilyControls
import ManagedSettings

struct ContentView: View {
    @ObservedObject var store: MyModel
    
    @State private var isDiscouragedPresented = false
    //@State private var isEncouragedPresented = false
    
    
    var body: some View {
        VStack {
            Spacer()
            // 스크린 타임 권한 요청
            Button {
                requestScreenTimePermission()
            } label: {
                Text("Request Screen Time Authorization")
            }
            .padding()
            
            // 노티피케이션 권한 요천
            Button {
                NotificationManager.shared.requestAuthorization()
            } label: {
                Text("Request Notification Authorization")
            }
            .padding()

            
            Spacer()
            
            Button("Select Apps to Discourage") {
                isDiscouragedPresented = true
            }
            .familyActivityPicker(isPresented: $isDiscouragedPresented, selection: MyModel.shared.$selectedApps)
            .padding()
            .foregroundColor(.gray)
            
//            Button("Select Apps to Encourage") {
//                isEncouragedPresented = true
//            }
//            .familyActivityPicker(isPresented: $isEncouragedPresented, selection: $model.selectionToEncourage)
            Spacer()
            
            // 제한 시작 버튼
            Button {
//                print("Discouraged apps: \(MyModel.shared.$selectedApps)")
//                print("Discoureged app numbers: \(MyModel.shared.$selectedApps.applications.count)")
//                // 시간 설정
//                print("Setting schedule...")
//                let hourComponents = Calendar.current.dateComponents([.hour], from: Date())
//                let curHour = hourComponents.hour ?? 0
//
//                let minuteComponents = Calendar.current.dateComponents([.minute], from: Date())
//                let curMins = minuteComponents.minute ?? 0
//                print("CURRENT TIME: \(curHour):\(curMins)")
//
//                var endHour = curHour + 0
//                var endMins = curMins + 5
//                if(endMins >= 60) {
//                    endMins -= 60
//                    endHour += 1
//                }
//                if(endHour > 23) {
//                    endHour = 23
//                    endMins = 59
//                }
//                print("END TIME: \(endHour):\(endMins)")

//                MySchedule.setSchedule(curHour: curHour, curMins: curMins, endHour: endHour, endMins: endMins)
                handleStartDeviceActivityMonitoring()

            } label: {
                ZStack {
                    Color.orange
                    Text("Start shield")
                        .foregroundColor(.black)
                        .font(.title2)
                }
                .frame(width: UIScreen.main.bounds.width*0.8, height: 50)
                .cornerRadius(15)
            }
            
            Button {
                handleSetBlockApplication()
            } label: {
                Text("Block shield")
            }
            
            Button {
                handleResetSelection()
            } label: {
                Text("Reset shielded apps")
            }


            
//            // 제한 풀기 버튼
//            Button {
//                let store = ManagedSettingsStore()
//                store.shield.applications = nil
//                store.shield.applicationCategories = nil
//                print("Application shields are removed!!")
//            } label: {
//                ZStack {
//                    Color.black
//                    Text("Remove Shield.")
//                        .foregroundColor(.red)
//                        .font(.title2)
//                }
//                .frame(width: UIScreen.main.bounds.width*0.8, height: 50)
//                .cornerRadius(15)
//            }



        }
        .padding()
//        // selectionToDiscourage 값이 변경될 때마다 모델의 shield 세팅 값 변경
//        .onChange(of: model.selectionToDiscourage) { newSelection in
//            MyModel.shared.setShieldRestriction()
//        }
    }
}

extension ContentView {
    //MARK: 스크린터임 권한 요청
    private func requestScreenTimePermission() {
        let center = AuthorizationCenter.shared
        
        if center.authorizationStatus == .approved {
            print("ScreenTime Permission approved")
        } else {
            print("Request ScreenTime Permission...")
            Task {
                do {
                    try await center.requestAuthorization(for: .individual)
                    print("Approved Status: \(AuthorizationStatus.approved)")
                } catch {
                    print("Failed to enroll User with error: \(error)")
                }
            }
        }
    }
    
//    //MARK: 노티피케이션 권한 요청
//    private func requestNotificationPermission() {
//        let center = UNUserNotificationCenter.current()
//
//        center.getNotificationSettings { settings in
//            switch settings.alertSetting {
//            case .enabled:
//                print("Notification Permission approved!!")
//            default:
//                print("Notification Permission NOT approved")
//
//            Task {
//                do {
//                    try await center.requestAuthorization(options: [.alert, .badge, .sound])
//                } catch {
//                    print("Failed to enroll Aniyah with error: \(error)")
//                }
//
//            }
//            }
//        }
//    }
    
    //MARK: 현재 선택된 앱 초기화
    private func handleResetSelection() {
        MyModel.shared.handleResetSelection()
        handleStartDeviceActivityMonitoring(includeUsageThreshold: false)
    }
    
    //MARK: 앱 제한 모니터링 등록 및 시작
    private func handleStartDeviceActivityMonitoring(includeUsageThreshold: Bool = true) {
        MyModel.shared.handleStartDeviceActivityMonitoring(includeUsageThreshold: includeUsageThreshold)
    }
    
    private func handleSetBlockApplication() {
        MyModel.shared.handleSetBlockApplication()
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(store: MyModel.shared)
    }
}
