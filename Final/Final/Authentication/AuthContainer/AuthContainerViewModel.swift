//
//  AuthContainerViewModel.swift
//  Final
//
//  Created by nika kovziridze on 09.01.26.
//

import Foundation

final class AuthContainerViewModel {

    enum Mode {
        case login
        case register
    }

    var onModeChange: ((Mode) -> Void)?
    private(set) var mode: Mode = .login

    func switchMode(_ newMode: Mode) {
        mode = newMode
        onModeChange?(mode)
    }

}
