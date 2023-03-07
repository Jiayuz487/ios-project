//
//  HelpFunctions.swift
//  ECE564_HW
//
//  Created by zjy on 1/26/22.
//  Copyright © 2022 ECE564. All rights reserved.
//

import SwiftUI

/*
 Generate a comma seperated String from the given String list.
 e.g. ["Reading", "Skiing"] -> "Reading, Skiing"
 */
func listToString(list: [String]) -> String {
    if list.count == 0 {
        return "N/A"
    }
    else {
        var str : String = ""
        for idx in 1...list.count {
            if idx != 1 {
                str += ", "
            }
            str += list[idx-1]
        }
        return str
    }
}

/*
 Cast Base64 encoded String to UIImage.
 */
func StringToImage(_ base64: String?) -> UIImage {
    if let base64 = base64 {
        let data = Data(base64Encoded: base64)
        if let img = UIImage(data: data!) {
            return img
        }
    }
    return UIImage(named: "blank")!
}

/*
 Cast UIImage to Base64 encoded String.
 */
func ImageToString(_ img: UIImage) -> String {
    let data : Data = img.jpegData(compressionQuality: 1)!
    return data.base64EncodedString()
}

/*
 Map gender String to Enum.
 */
func genderStringToEnum(gender: String) -> Gender {
    var genderEnum : Gender
    switch gender {
    case "Male":
        genderEnum = .Male
    case "Female":
        genderEnum = .Female
    case "Non-binary":
        genderEnum = .NonBinary
    default:
        genderEnum = .Unknown
    }
    return genderEnum
}
/*
 Map gender Enum to String.
 */
func genderEnumToString(genderEnum: Gender) -> String {
    var gender : String
    switch genderEnum {
    case .Male:
        gender = "Male"
    case .Female:
        gender = "Female"
    case .NonBinary:
        gender = "Non-binary"
    default:
        gender = "Unknown"
    }
    return gender
}

/*
 Map gender Enum to Segmented Control index.
 */
func genderEnumToIndex(genderEnum: Gender) -> Int {
    var idx : Int
    switch genderEnum {
    case .Male:
        idx = 0
    case .Female:
        idx = 1
    case .NonBinary:
        idx = 2
    default:
        idx = 3
    }
    return idx
}

/*
 Map gender Segmented Control index to Enum.
 */
func genderIndexToEnum(idx: Int) -> Gender {
    var genderEnum : Gender
    switch idx {
    case 0:
        genderEnum = .Male
    case 1:
        genderEnum = .Female
    case 2:
        genderEnum = .NonBinary
    default:
        genderEnum = .Unknown
    }
    return genderEnum
}

/*
 Map role String to Enum.
 */
func roleStringToEnum(role: String) -> DukeRole {
    var roleEnum : DukeRole
    switch role {
    case "Student":
        roleEnum = .Student
    case "Professor":
        roleEnum = .Professor
    case "Teaching Assistant":
        roleEnum = .TA
    case "TA":
        roleEnum = .TA
    default:
        roleEnum = .Other
    }
    return roleEnum
}

/*
 Map role Enum to String.
 */
func roleEnumToString(roleEnum: DukeRole) -> String {
    var role : String
    switch roleEnum {
    case .Student:
        role = "Student"
    case .Professor:
        role = "Professor"
    case .TA:
        role = "TA"
    default:
        role = "Other"
    }
    return role
}

/*
 Map role Enum to Segmented Control index.
 */
func roleEnumToIndex(roleEnum: DukeRole) -> Int {
    var idx : Int
    switch roleEnum {
    case .Professor:
        idx = 0
    case .Student:
        idx = 1
    case .TA:
        idx = 2
    default:
        idx = 3
    }
    return idx
}

/*
 Map role Segmented Control index to Enum.
 */
func roleIndexToEnum(idx: Int) -> DukeRole {
    var roleEnum : DukeRole
    switch idx {
    case 0:
        roleEnum = .Professor
    case 1:
        roleEnum = .Student
    case 2:
        roleEnum = .TA
    default:
        roleEnum = .Other
    }
    return roleEnum
}

/*
 Generate description for the given DukePerson.
 */
func generateDescription(person: DukePerson) -> String {
    var pronoun : String
    var be : String
    
    switch person.gender {
    case .Male:
        pronoun = "He"
        be = "is"
    case .Female:
        pronoun = "She"
        be = "is"
    default:
        pronoun = "They"
        be = "are"
    }

    return "\(person.firstName) \(person.lastName) \(be) from \(person.whereFrom). \(pronoun) \(be) a \(person.degree) \(person.role) who loves \(listToString(list: person.hobbies)) and can program in \(listToString(list: person.languages))."
}

/*
 Generate netid list from roster indices list.
 */
func rosterIndicesToNetids(indices: [Int]) -> [String] {
    var netids : [String] = []
    for idx in indices {
        netids.append(DataBase.roster[idx].netid)
    }
    return netids
}

/* Authorization Info */
let username = "jz370"
let token = "AE1F086E756E13021F188ED0EC0D502D"
let loginString = "\(username):\(token)"
let httpString = "http://kitura-fall-2021.vm.duke.edu:5640/b64entries"

/* Document Path */
let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
let documentURL = documentsDirectory.appendingPathComponent("databaseJSONFile")

/*
 Hardcoded database records.
 */
let jiayu : DukePerson = DukePerson(firstName: "Jiayu", lastName: "Zhang", netid: "jz370", role: .Student, gender: .Female, whereFrom: "Zhejiang, China", hobbies: ["Traveling"], languages: ["C++", "Python", "Javascript"], degree: "Bachelor of Science", team: "N/A", photo: UIImage(named: "jiayu")!, department: "ECE", email: "jz370@duke.edu", id: "jz370")
let richard : DukePerson = DukePerson(firstName: "Richard", lastName: "Telford", netid: "rt113", role: .Professor, gender: .Male, whereFrom: "Chatham County, NC", hobbies: ["Reading", "Golf", "Swimming"], languages: ["Swift", "C", "C++"], degree: "NA", team: "N/A", photo: UIImage(named: "telford")!, department: "N/A", email: "rt113@duke.edu", id: "rt113")
let wenxin : DukePerson = DukePerson(firstName: "Wenxin", lastName: "Xu", netid: "wx65", role: .TA, gender: .Female, whereFrom: "Chengdu, China", hobbies: ["Photography", "Ultimate Frisbee"], languages: ["Swift", "Java", "Python"], degree: "Bachelor of Science", team: "NA", photo: UIImage(named: "wenxin")!, department: "N/A", email: "wx65@duke.edu", id: "wx65")
let anshu : DukePerson = DukePerson(firstName: "Anshu", lastName: "Dwibhashi", netid: "ad353", role: .TA, gender: .Male, whereFrom: "Bangalore, India", hobbies: ["Punk rock music", "playing guitar"], languages: ["Swift", "C/C++", "Python"], degree: "BSE, MEng", team: "N/A", photo: UIImage(named: "anshu")!, department: "", email: "ad353@duke.edu", id: "ad353")
let andrew : DukePerson = DukePerson(firstName: "Andrew", lastName: "Krier", netid: "ak513", role: .TA, gender: .Male, whereFrom: "Saint Paul, Minnesota", hobbies: ["Frisbee", "Basketball"], languages: ["Swift", "Java", "Python"], degree: "BSE", team: "N/A", photo: UIImage(named: "krier")!, department: "N/A", email: "ak513@duke.edu", id: "ak513")
