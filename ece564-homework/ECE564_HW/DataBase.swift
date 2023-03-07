//
//  DataBase.swift
//  ECE564_HW
//
//  Created by zjy on 1/26/22.
//  Copyright © 2022 ECE564. All rights reserved.
//

import SwiftUI

class DataBase {
    static var roster = [DukePerson]()
    static var rosterWithSection = [(String, [DukePerson])]()
    
    /*
     Get section index.
     */
    static func getSectionIndex(key: String) -> Int {
        if rosterWithSection.count == 0 {
            return -1
        }
        
        for i in 0...rosterWithSection.count-1 {
            if key == rosterWithSection[i].0 {
                return i
            }
        }
        return -1
    }
    
    /*
     Insert new record into section.
     */
    static func insertIntoSection(idx: Int, key: String, person: DukePerson) {
        if idx == -1 {
            rosterWithSection.append((key, [person]))
        }
        else {
            rosterWithSection[idx].1.append(person)
        }
    }
    
    /*
     Divide DukePerson into different sections.
     */
    static func generateSection() {
        rosterWithSection = [(String, [DukePerson])]()
        for person in roster {
            if person.role == DukeRole.Professor {
                let idx = getSectionIndex(key: "Professor")
                insertIntoSection(idx: idx, key: "Professor", person: person)
            }
            else if person.role == DukeRole.TA {
                let idx = getSectionIndex(key: "Teaching Assistant")
                insertIntoSection(idx: idx, key: "Teaching Assistant", person: person)
            }
            else if person.role == DukeRole.Other {
                let idx = getSectionIndex(key: "Other")
                insertIntoSection(idx: idx, key: "Other", person: person)
            }
            else {
                let teamName = person.team.lowercased()
                if teamName == "tbd" || teamName == " " || teamName == "n/a" || teamName == "na" || teamName == "none" {
                    let idx = getSectionIndex(key: "Student")
                    insertIntoSection(idx: idx, key: "Student", person: person)
                }
                else {
                    let idx = getSectionIndex(key: person.team)
                    insertIntoSection(idx: idx, key: person.team, person: person)
                }
            }
        }
    }
    
    /*
     Write default records to the database.
     */
    static func start() -> Void {
        loadDataBase()
        if roster.count == 0 {
            roster.append(contentsOf: [jiayu, richard, wenxin, anshu, andrew])
        }
        generateSection()
    }
    
    /*
     Search the database by netID.
     */
    static func findByNetid(netid: String, indices: [Int]) -> [Int] {
        if netid.count != 0 {
            for idx in 1...roster.count {
                if roster[idx-1].netid == netid {
                    return [idx-1]
                }
            }
            return []
        }
        return indices
    }
    
    /*
     Search the database by last name.
     */
    static func findByLastName(lastName: String, indices: [Int]) -> [Int] {
        if lastName.count != 0 {
            var ans : [Int] = []
            for idx in indices {
                if roster[idx].lastName == lastName {
                    ans.append(idx)
                }
            }
            return ans
        }
        else {
            return indices
        }
    }
    
    /*
     Search the database by first name.
     */
    static func findByFirstName(firstName: String, indices: [Int]) -> [Int] {
        if firstName.count != 0 {
            var ans : [Int] = []
            for idx in indices {
                if roster[idx].firstName == firstName {
                    ans.append(idx)
                }
            }
            return ans
        }
        else {
            return indices
        }
    }
    
    /*
     Search the database by where from.
     */
    static func findByWhereFrom(whereFrom: String, indices: [Int]) -> [Int] {
        if whereFrom.count != 0 {
            var ans : [Int] = []
            for idx in indices {
                if roster[idx].whereFrom == whereFrom {
                    ans.append(idx)
                }
            }
            return ans
        }
        else {
            return indices
        }
    }
    
    /*
     Search the database by degree.
     */
    static func findByDegree(degree: String, indices: [Int]) -> [Int] {
        if degree.count != 0 {
            var ans : [Int] = []
            for idx in indices {
                if roster[idx].degree == degree {
                    ans.append(idx)
                }
            }
            return ans
        }
        else {
            return indices
        }
    }
    
    /*
     Search the database by team.
     */
    static func findByTeam(team: String, indices: [Int]) -> [Int] {
        if team.count != 0 {
            var ans : [Int] = []
            for idx in indices {
                if roster[idx].team == team {
                    ans.append(idx)
                }
            }
            return ans
        }
        else {
            return indices
        }
    }
    
    /*
     Search the database by email.
     */
    static func findByEmail(email: String, indices: [Int]) -> [Int] {
        if email.count != 0 {
            var ans : [Int] = []
            for idx in indices {
                if roster[idx].email == email {
                    ans.append(idx)
                }
            }
            return ans
        }
        else {
            return indices
        }
    }
    
    /*
     Search the database by gender.
     */
    static func findByGender(genderIdx: Int, indices: [Int]) -> [Int] {
        var ans : [Int] = []
        for idx in indices {
            if roster[idx].gender == genderIndexToEnum(idx: genderIdx) {
                ans.append(idx)
            }
        }
        return ans
    }
    
    /*
     Search the database by role.
     */
    static func findByRole(roleIdx: Int, indices: [Int]) -> [Int] {
        var ans : [Int] = []
        for idx in indices {
            if roster[idx].role == roleIndexToEnum(idx: roleIdx) {
                ans.append(idx)
            }
        }
        return ans
    }
    
    /*
     General entrance for search operation.
     */
    static func find(netid: String, firstName: String, lastName: String, whereFrom: String, degree: String, team: String, genderIdx: Int, roleIdx: Int, department: String, email: String) -> [Int] {
        var indices : [Int] = Array(0...roster.count-1)
        indices = findByNetid(netid: netid, indices: indices)
        indices = findByEmail(email: email, indices: indices)
        indices = findByFirstName(firstName: firstName, indices: indices)
        indices = findByLastName(lastName: lastName, indices: indices)
        indices = findByWhereFrom(whereFrom: whereFrom, indices: indices)
        indices = findByDegree(degree: degree, indices: indices)
        indices = findByGender(genderIdx: genderIdx, indices: indices)
        indices = findByRole(roleIdx: roleIdx, indices: indices)
        return indices
    }
    
    /*
     Add or Update info to the database.
     */
    static func addOrUpdate(currentPerson: DukePerson) -> String {
        if currentPerson.netid.count == 0 {
            return "Missing field netid."
        }
        
        let indices = findByNetid(netid: currentPerson.netid, indices: Array(0...roster.count-1))
        if indices.count == 0 {
            roster.append(currentPerson)
            return "The person with netid " + currentPerson.netid + " has been added."
        }
        else {
            currentPerson.department = roster[indices[0]].department
            currentPerson.id = roster[indices[0]].id
            roster[indices[0]] = currentPerson
            return "The person with netid " + currentPerson.netid + " has been updated."
        }
    }
    
    static func remove(currentPerson: DukePerson) {
        for i in 0...roster.count-1 {
            if currentPerson.netid == roster[i].netid {
                roster.remove(at: i)
                break
            }
        }
    }
    
    /*
     Save data to a file.
     */
    static func saveDataBase() -> Void {
        let encoder = JSONEncoder()
        var arr : [CodableDukePerson] = []
        for person in roster {
            arr.append(person.toCodableDukePerson())
        }
        
        var err : Error?
        if let encoded = try? encoder.encode(arr) {
            do {
                try encoded.write(to: documentURL)
            } catch let error {
                err = error
            }
            if (err != nil) {
                print(err as Any)
            }
        }
    }
    
    /*
     Read data from the file.
     */
    static func loadDataBase() -> Void {
        let decoder = JSONDecoder()
        let data : Data

        do {
            data = try Data(contentsOf: documentURL)
        } catch let error {
            print(error as Any)
            return
        }

        roster = [DukePerson]()
        if let decoded = try? decoder.decode([CodableDukePerson].self, from: data) {
            for person in decoded {
                person.addToRoster()
            }
        }
    }
}
