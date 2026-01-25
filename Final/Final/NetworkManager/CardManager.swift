//
//  CardManager.swift
//  Final
//
//  Created by nika kovziridze on 13.01.26.
//

import FirebaseFirestore
import FirebaseAuth

final class CardManager {

    private let db = Firestore.firestore()

    private var userId: String? {
        Auth.auth().currentUser?.uid
    }

    func addCard(_ card: PaymentCard, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let userId else { return }

        do {
            try db.collection("users")
                .document(userId)
                .collection("cards")
                .addDocument(from: card) { error in
                    if let error = error {
                        completion(.failure(error))
                    } else {
                        completion(.success(()))
                    }
                }
        } catch {
            completion(.failure(error))
        }
    }

    func fetchCards(completion: @escaping (Result<[PaymentCard], Error>) -> Void) {
        guard let userId else { return }

        db.collection("users")
            .document(userId)
            .collection("cards")
            .order(by: "createdAt", descending: true)
            .getDocuments { snapshot, error in
                if let error = error {
                    completion(.failure(error))
                    return
                }

                let cards = snapshot?.documents.compactMap {
                    try? $0.data(as: PaymentCard.self)
                } ?? []

                completion(.success(cards))
            }
    }

    func deleteCard(cardId: String, completion: @escaping (Result<Void, Error>) -> Void) {
        guard let userId else { return }

        db.collection("users")
            .document(userId)
            .collection("cards")
            .document(cardId)
            .delete { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(()))
                }
            }
    }
}

