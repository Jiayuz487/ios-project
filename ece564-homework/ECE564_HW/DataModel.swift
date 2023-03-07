//
//  DataModel.swift
//  ECE564_HW
//
//  Created by zjy on 1/26/22.
//  Copyright © 2022 ECE564. All rights reserved.
//

import SwiftUI

enum Gender : String {
    case Male = "Male"
    case Female = "Female"
    case NonBinary = "Non-binary"
    case Unknown = "Unknown"
}

class Person {
    var firstName = "First"
    var lastName = "Last"
    var whereFrom = "Anywhere"  // this is just a free String - can be city, state, both, etc.
    var gender : Gender = .Male
    var hobbies = ["none"]
}

enum DukeRole : String {
    case Student = "Student"
    case Professor = "Professor"
    case TA = "Teaching Assistant"
    case Other = "Other"
}

protocol ECE564 {
    var degree : String { get }
    var languages: [String] { get }
    var team : String { get }
}

class DukePerson : Person, ECE564, CustomStringConvertible {
    var id : String = ""
    var role : DukeRole = .Professor
    var netid : String = ""
    var photo = UIImage(named: "blank")
    
    var degree : String = ""
    var languages : [String] = []
    var team : String = ""
    
    var department : String = ""
    var email : String = ""
    
    var description: String {
        return generateDescription(person: self)
    }
    
    override init() {
        super.init()
    }
    
    init(firstName: String, lastName: String, netid: String, role: DukeRole, gender: Gender, whereFrom: String, hobbies: [String], languages: [String], degree: String, team: String, photo: UIImage, department: String, email: String, id: String) {
        super.init()
        self.firstName = firstName
        self.lastName = lastName
        self.netid = netid
        self.role = role
        self.gender = gender
        self.whereFrom = whereFrom
        self.hobbies = hobbies
        self.languages = languages
        self.degree = degree
        self.team = team
        self.photo = photo
        self.department = department
        self.email = email
        self.id = id
    }
    
    /*
     Generate CodableDukePerson from DukePerson.
     */
    func toCodableDukePerson() -> CodableDukePerson {
        return CodableDukePerson(person: self, photo: ImageToString(photo ?? UIImage(named: "blank")!))
    }
}

class CodableDukePerson : Codable {
    let id, netid, firstname, lastname, wherefrom, gender, role, degree, team, department, email : String
    let picture : String?
    let hobbies, languages : [String]
    
    init(person: DukePerson, photo: String) {
        let gender = genderEnumToString(genderEnum: person.gender)
        let role = roleEnumToString(roleEnum: person.role)
        
        self.id = person.id
        self.netid = person.netid
        self.firstname = person.firstName
        self.lastname = person.lastName
        self.wherefrom = person.whereFrom
        self.gender = gender
        self.role = role
        self.degree = person.degree
        self.team = person.team
        self.department = person.department
        self.email = person.email
        self.hobbies = person.hobbies
        self.languages = person.languages
        self.picture = photo
    }
    
    /*
     Generate DukePerson from CodableDukePerson.
     */
    func toDukePerson() -> DukePerson {
        let genderEnum = genderStringToEnum(gender: gender)
        let roleEnum = roleStringToEnum(role: role)
        return DukePerson(firstName: firstname, lastName: lastname, netid: netid, role: roleEnum, gender: genderEnum, whereFrom: wherefrom, hobbies: hobbies, languages: languages, degree: degree, team: team, photo: StringToImage(picture), department: department, email: email, id: id)
    }
    
    /*
     Add current CodableDukePerson to database.
     */
    func addToRoster() {
        DataBase.roster.append(self.toDukePerson())
    }
}
