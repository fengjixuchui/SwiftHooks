//import SwiftUI
//
//@available(OSX 10.15, *)
//struct MyView: View {
//    var body: some View {
//        HStack {
//            Text("ABC")
//        }
////        Text("AB")
//    }
//}

protocol Commands { }

extension Command: Commands { }

@_functionBuilder
struct CommandsBuilder: Commands {
    static func buildBlock(_ commands: Command...) -> CommandList {
        return CommandList(commands: { commands })
    }
    
    static func buildExpression(_ commands: Command...) -> CommandList {
        return CommandList(commands: { commands })
    }
}

@_functionBuilder
struct CommandListBuilder: Commands {
    static func buildBlock(_ commands: Command...) -> [Command] {
        return commands
    }
    
    static func buildBlock(_ command: Command) -> [Command] {
        return [command]
    }
}

struct Group: Commands {
    var name: String
    var commands: [Command]
    
    init(_ name: String, @CommandListBuilder commands: () -> [Command]) {
        self.name = name
        self.commands = commands()
    }
}

struct CommandList: Commands {
    var commands: [Command]
    
    init(@CommandListBuilder commands: () -> [Command]) {
        self.commands = commands()
    }
}

let list = CommandList {
    Command(trigger: "abc", arguments: [], aliases: [], group: nil, permissionChecks: [], userInfo: [:]) { (_, _, _) in
        
    }
    Command(trigger: "abc", arguments: [], aliases: [], group: nil, permissionChecks: [], userInfo: [:]) { (_, _, _) in
        
    }
}


protocol Plugin {
    
    associatedtype C: Commands
    
    var commands: C { get }
}

//@available(OSX 10.15.0, *)
//struct PluginOne: Plugin {
//
//    @CommandsBuilder
//    var commands: some Commands {
//        // Error here
//        Command(trigger: "abc", arguments: [], aliases: [], group: nil, permissionChecks: [], userInfo: [:]) { (_, _, _) in
//
//        }
//        Command(trigger: "abc", arguments: [], aliases: [], group: nil, permissionChecks: [], userInfo: [:]) { (_, _, _) in
//
//        }
//    }
//}

@available(OSX 10.15.0, *)
struct PluginTwo: Plugin {

    var commands: some Commands {
        // Works
        Group("control") {
            Command(trigger: "abc", arguments: [], aliases: [], group: nil, permissionChecks: [], userInfo: [:]) { (_, _, _) in
                
            }
            Command(trigger: "abc", arguments: [], aliases: [], group: nil, permissionChecks: [], userInfo: [:]) { (_, _, _) in
                
            }
        }
    }
}

@available(OSX 10.15.0, *)
struct PluginThree: Plugin {

    var commands: some Commands {
        // Works
        CommandList {
            Command(trigger: "abc", arguments: [], aliases: [], group: nil, permissionChecks: [], userInfo: [:]) { (_, _, _) in

            }
            Command(trigger: "abc", arguments: [], aliases: [], group: nil, permissionChecks: [], userInfo: [:]) { (_, _, _) in

            }
        }
    }
}
