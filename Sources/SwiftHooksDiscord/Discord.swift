public final class DiscordHook: Hook {
    public init<O>(_ options: O, hooks: SwiftHooks?) where DiscordHook == O.H, O : HookOptions {
        guard let options = options as? DiscordHookOptions else {
            fatalError("DiscordHook must always be initialized with `DiscordHookOptions`")
        }
        
        self.token = options.token
        self.discordListeners = [:]
    }
    
    public func boot() throws { SwiftHooks.logger.info("Connecting \(self.self)") }
    public func shutDown() throws { SwiftHooks.logger.info("Shutting down \(self.self)") }
    
    var token: String
    
    public internal(set) var discordListeners: [DiscordEvent: [EventClosure]]
    
    public weak var hooks: SwiftHooks?
    
    public func listen<T, I>(for event: T, _ handler: @escaping EventHandler<I>) where T : MType, I == T.ContentType {
        guard let event = event as? DiscordMType<I, DiscordEvent> else { return }
        var closures = self.discordListeners[event, default: []]
        closures.append { (event, data) in
            guard let object = event.getData(I.self, from: data) else {
                SwiftHooks.logger.debug("Unable to extract \(I.self) from data.")
                return
            }
            try handler(object)
        }
        self.discordListeners[event] = closures
    }
}

public struct DiscordHookOptions: HookOptions {
    public typealias H = DiscordHook
    
    var token: String
    
    public init(token: String) {
        self.token = token
    }
}

public struct DiscordMType<ContentType, E: EventType>: MType {
    public let event: E
    public init(_ e: E, _ t: ContentType.Type) {
        self.event = e
    }
}

public struct Guild {
    public let name: String
}

public enum DiscordEvent: EventType {
    case _guildCreate

    public static let guildCreate = DiscordMType(DiscordEvent._guildCreate, Guild.self)
}