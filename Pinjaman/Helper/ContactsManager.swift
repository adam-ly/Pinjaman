import SwiftUI
import Contacts

class ContactsManager: ObservableObject {

    @Published var isShowingContactPicker = false
    @Published var isShowingPermissionAlert = false

    private var completionHandler: ((_ contact: (name: String, number: String)?) -> Void)?

    func showContactPicker(
        completion: @escaping (_ contact: (name: String, number: String)?) -> Void
    ) {
        let store = CNContactStore()
        self.completionHandler = completion

        let status = CNContactStore.authorizationStatus(for: .contacts)

        switch status {
        case .authorized:
            DispatchQueue.main.async {
                self.isShowingContactPicker = true
            }

        case .notDetermined:
            store.requestAccess(for: .contacts) { [weak self] granted, _ in
                DispatchQueue.main.async {
                    granted
                    ? (self?.isShowingContactPicker = true)
                    : self?.handlePermissionDenied()
                }
            }

        default:
            handlePermissionDenied()
        }
    }

    func handleContactSelection(
        contact: (name: String, number: String)?
    ) {
        self.isShowingContactPicker = false
        self.completionHandler?(contact)
        self.completionHandler = nil
    }

    private func handlePermissionDenied() {
        self.isShowingPermissionAlert = true
        self.completionHandler?(nil)
        self.completionHandler = nil
        NotificationCenter.postAlert(alertType: .contact)
    }
}
