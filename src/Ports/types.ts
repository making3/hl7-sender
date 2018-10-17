interface SubscriptionWithParameters<T> {
  subscribe: (callback: (data: T) => void) => void;
}
interface SubscriptionWithoutParameters {
  subscribe: (callback: () => void) => void;
}
interface Response<T> {
  send: (response: T) => void;
}

export interface App {
  ports: {
    connect: SubscriptionWithParameters<string[]>,
    disconnect: SubscriptionWithoutParameters,
    send: SubscriptionWithParameters<string>,
    sent: Response<null>,
    getConnections: SubscriptionWithParameters<string>,
    initialSavedConnections: Response<string[]>,
    saveConnection: SubscriptionWithParameters<string>,
    savedNewConnection: Response<string>,
    savedConnection: Response<string>,
    connected: Response<null>,
    connectionError: Response<string>,
    disconnected: Response<null>,
    ack: Response<string>,
    settingsSave: SubscriptionWithParameters<string>,
    settingsSaved: Response<string>,
    settingsGet: SubscriptionWithParameters<string>,
    settings: Response<string[]>,
    versionGet: SubscriptionWithoutParameters,
    version: Response<string>,
    menuClick: Response<string>
  };
}
