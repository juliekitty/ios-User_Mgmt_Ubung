import SwiftUI
import AudioToolbox

struct MyLoginData {
    let userName: String = "Julie"
    let password: String = "mdp"
}

struct ContentView: View {
    
    private let myLoginData: MyLoginData = MyLoginData()
    
    @State var userName: String = ""
    @State var password: String = ""
    @State var showingAlert: Bool = false
    
    @State var showLoggedInView: Bool = false
    
    var body: some View {
        NavigationView {
            LogInFormView
                .navigationTitle("Start")
                .navigationBarTitleDisplayMode(.large)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
    
    
    private var LogInFormView: some View {
        VStack {
            NavigationLink(destination: LoggedInView(), isActive: $showLoggedInView) {
                EmptyView()
            }
            Form {
                HStack {
                    TextField("UserName", text: $userName)
                    Image(systemName: "person") .font(Font.system(.callout))
                }
                HStack {
                    SecureField("Password", text: $password)
                    Image(systemName: "lock") .font(Font.system(.callout))
                }
                
                Button(action: {
                    showingAlert = testLoginData()
                }, label: {
                    Text("Login")
                        .frame(maxWidth: .infinity, alignment: .center)
                })
            }
            .disableAutocorrection(true)
            .onChange(of: userName) { newInput in
                //print("newInput: \(newInput)")
            }
        }
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Login failed"), message: Text("try again"), dismissButton: .default(Text("Got it!")))
        }
    }
    
    private func testLoginData() -> Bool {
        guard password == myLoginData.password else {
            userName = ""
            password = ""
            AudioServicesPlayAlertSoundWithCompletion(SystemSoundID(kSystemSoundID_Vibrate)) { return }

            return true }
        guard userName == myLoginData.userName else {
            userName = ""
            password = ""
            AudioServicesPlayAlertSoundWithCompletion(SystemSoundID(kSystemSoundID_Vibrate)) { return }

            return true
         
         }
        print("login")
        showLoggedInView = true
        return false
    }
    
}

struct LoggedInView: View {
    @State var showUserListView: Bool = false
    @State var showUserFormView: Bool = false
    @State var userRepository: Repository = Repository()
    
    var body: some View {
        ZStack {
            NavigationLink(destination: UserListView(userRepository: userRepository, showUserListView: showUserListView), isActive: $showUserListView) {
                EmptyView()
            }
            NavigationLink(destination: UserFormView(userRepository: $userRepository, showUserListView: showUserListView), isActive: $showUserFormView) {
                Text("Add user")
            }
            Color.neuGray
                .cornerRadius(10)
                .padding(20)
            
            VStack(spacing: 100) {
                
                Button(action: {
                    showUserListView = true
                }, label: {
                    Text("Go to users list") .font(Font.system(.subheadline).bold())
                })
                .padding(20)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.white)
                        .shadow(radius: 3)
                )
                
                Button(action: {
                    showUserFormView = true
                }, label: {
                    Text("Add a user") .font(Font.system(.subheadline).bold())
                })
                .padding(20)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.white)
                        .shadow(radius: 3)
                )
            }
            .navigationTitle("Welcome")
            .navigationBarTitleDisplayMode( .large)
            .navigationBarItems( // better: toolbarItem
                trailing:
                    HStack {

                        Button(action: {
                            showUserFormView = true
                        }) {
                            Image(systemName: "person.badge.plus")
                                .font(.largeTitle)
                        }.foregroundColor(.gray)
                    })
            
        }
        
        
    }
    
}

struct UserListView: View {
    @State var userRepository: Repository
    @State var showUserListView: Bool
    
    var body: some View {
        
        ZStack {
            Color(UIColor.cyan)
                .navigationTitle("Users List")
                .navigationBarTitleDisplayMode( .large)
            NavigationLink(
                destination: UserFormView(userRepository: $userRepository, showUserListView: showUserListView)) {
                Image(systemName: "arrow.right")
                    .font(Font.system(size: 60, weight: .black))
                
            }
            List {
                ForEach(userRepository.users.sorted { $0.timeStamp > $1.timeStamp}) { user in
                    VStack(alignment: .leading, spacing: 10) {
                        HStack(alignment: .top, spacing: 10, content: {
                            Text("\(user.name), \(String(user.age))")
                                .bold()
                            Spacer()
                            Image(systemName: "person") .font(Font.system(.callout))
                        })
                        VStack(alignment: .leading, spacing: 0, content: {
                            Text("Created: \(String(user.convertDateFormatter(date: user.timeStamp)))").font(.footnote)
                            // Text(String(user.id.description)).font(.footnote)
                        })
                        Spacer()
                    }
                }
            }
            .listStyle(InsetListStyle())
        }
    }
}

struct UserFormView: View {
    @Binding var userRepository: Repository
    @State var showUserListView: Bool = false
    
    @State var name: String = ""
    @State var age: String = ""
    let id: UUID = UUID()
    
    @Environment(\.presentationMode) var presentationMode
    @Environment(\.isNotchDevice) var isNotchDevice
    
    @State var showingAlert = false

   var body: some View {
        
        NavigationLink(destination: UserListView(userRepository: userRepository, showUserListView: showUserListView), isActive: $showUserListView) {
            EmptyView()
        }
        
        Form {
            HStack {
                TextField("Name", text: $name)
                Image(systemName: "person") .font(Font.system(.callout))
            }
            HStack {
                TextField("Age", text: $age).keyboardType(.numberPad)
                Image(systemName: "calendar") .font(Font.system(.callout))
            }
            
            Button(action: {
                if (name.isEmpty || age.isEmpty) {
                    self.showingAlert = true
                } else {
                    let newUser = User(name: name, age: Int(age) ?? 0 , id: id, timeStamp: Date())
                    let newList = userRepository.addUser(user: newUser)
                    print(newList.count)
                    showUserListView = true
                }
                
            }, label: {
                Text("Add")
                    .frame(maxWidth: .infinity, alignment: .center)
            })
        }.navigationTitle("Add a user")
        .navigationBarTitleDisplayMode( .large)
        .alert(isPresented: $showingAlert) {
            Alert(title: Text("Validation"), message: Text("Please enter a name and an age."), dismissButton: .default(Text("Got it!")))
        }
        /*.alert(isPresented: $showingAlert, content: {
            return Alert(title: Text("Save Product"), message: Text("Are you sure you want to save the changes made?"), primaryButton: .default(Text("Yes"), action: {
                //insert an action here
            }), secondaryButton: .destructive(Text("No")))
        })*/
    }
    
    
}

struct IsNotchDevice: EnvironmentKey {
    static let defaultValue: Bool = UIApplication.shared.windows.first?.safeAreaInsets.bottom != 0.0
}

extension EnvironmentValues {
    var isNotchDevice: Bool {
        get { self[IsNotchDevice] }
        set { self[IsNotchDevice] = newValue }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        LoggedInView(showUserListView: false, userRepository: Repository())
        UserListView(userRepository: Repository(), showUserListView: false)
    }
}
