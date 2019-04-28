import Foundation
//Class object model for event object
class EventBean {
    var Event_id : String = ""
    var Name_E : String = ""
    var Name_AR : String = ""
    var Start_date : String = ""
    var End_date : String = ""
    var Picture : String = ""
    var activities: [EventActivityBean] = [EventActivityBean]()
}
