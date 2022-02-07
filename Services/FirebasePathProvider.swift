import FirebaseFirestore

extension Firestore {
    
    func uidPhoneConformityDoc(byPhone phone: String) -> DocumentReference {
        self.collection("phones").document(phone)
    }
    
    func userDoc(withID id: String) -> DocumentReference {
        self.collection("users").document(id)
    }
    
    func userPhonebookDoc(withID id: String) -> DocumentReference {
        self.collection("users").document(id).collection("phonebook").document("phones")
    }
    
}
