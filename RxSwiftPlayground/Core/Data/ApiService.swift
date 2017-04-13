//
//  ApiService.swift
//  RxSwiftTrial
//
//  A generic protocol for loading and saving
//
//  Created by Julien Saito on 3/17/17.
//  Copyright © 2017 otiasj. All rights reserved.
//

import RxSwift

protocol ApiService {
    associatedtype T
    associatedtype P
    
    /**
     * Load some data
     */
    func load(withParams: P) -> Observable<T>
    
    /**
     * If this service can store Data then this method should be implemented
     * store the given value
     */
    func store(_ value: T, withParams: P)
    
    /**
     * If this service can store Data then this method should be implemented.
     * Clear data if any is stored for the given params
     */
    func clear(withParams: P)
}

extension ApiService {
    /**
     * If this service can store Data then this method should be implemented
     * store the given value
     */
    func store(_ value: T, withParams: P) {
    }
    
    
    /**
     * If this service can store Data then this method should be implemented.
     * Clear data if any is stored for the given params
     */
    func clear(withParams: P)  {
        
    }
}

