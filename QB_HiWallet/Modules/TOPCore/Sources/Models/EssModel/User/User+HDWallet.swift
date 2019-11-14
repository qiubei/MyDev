//
//  User+HDWallet.swift
//  TOPCore
//
//  Created by Jax on 12/28/18.
//  Copyright © 2018 Jax. All rights reserved.
//




extension User {
    public convenience init(mnemonic: String) {
        let seed =  MnemonicService.init().seed(from: mnemonic)//(inject() as MnemonicServiceInterface).seed(from: mnemonic)
        
        self.init(seed: seed)
        self.mnemonic = mnemonic
    }
    
    public convenience init(seed: String) {
        let index = ViewUserStorageService.init().freeIndex
        let name = "Settings.CurrentAccountTitle.Default" + " (\(index))"
        self.init(seed: seed, name: name)
    }
    
    public convenience init(mnemonic: String, name: String) {
        let seed = MnemonicService.init().seed(from: mnemonic)
        self.init(seed: seed, name: name)
        self.mnemonic = mnemonic
    }
    
    public convenience init(seed: String, name: String) {
        let id = seed.sha256()
        self.init(id: id, seed: seed, name: name)
    }
}
