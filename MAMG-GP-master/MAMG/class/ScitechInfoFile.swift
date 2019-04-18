//
//  ScitechInfoFile.swift
//  MAMG
//
//  Created by Areej on 2/10/19.
//  Copyright © 2019 Areej. All rights reserved.
//

import Foundation

// MARK : the class that holds the key values for scitech info

class ScitechInfo {
    var name : String = ""
    var imagName : String = ""
    var description: String = ""
    
    init(text : String, img : String, dis : String) {
        name = text
        imagName = img
        description = dis
    }
}

class ScitechInformation {
    var list = [ScitechInfo]()
    var languageIsItAr = true
    init(ar : Bool) {
        languageIsItAr = ar
        if(!languageIsItAr){
        list.append(ScitechInfo(text: "About Us", img: "Screen Shot 2019-01-15 at 6.55.30 AM", dis: "The Center was constructed on a 21,700 square meters land. The land is located on the North Corniche Road in Al-Khobar. And it is very attractive for tourists in the eastern province which is helping to publicize the center and attract visitors. The site at the eastern side of the Arabian gulf with its fascinating view had inspired the architectural concept of the project."))
         list.append(ScitechInfo(text: "Mission", img: "Screen Shot 2019-01-15 at 6.55.44 AM", dis: "Disseminate the principles of science and technical innovations by presenting them in new and interesting methods for members of the community, especially the youth in order to expand their horizons and to encourage their scientific interest in the areas of science and technology to be able to keep up with the development of science and technology, and to become qualified for developing themselves and their country to distinct levels."))
        list.append(ScitechInfo(text: "Objectives", img: "Screen Shot 2019-01-15 at 6.55.44 AM", dis: "● Broaden the scientific and cultural horizon of visitors in the areas of science and technology \n ● Simplify the ideas and scientific topics and make it interesting and enjoyable for all\n ● Development of the curiosity, reading and exploration in the areas of sciencen \n ● Help visitors to develop ways of thinking and scientific analysis and make it something natural in their lives.\n ● linking exhibit programs with the education curriculum in the kingdom\n ● Organizing temporary exhibitions in the fields of science and technology, such as science books, computers, communications and others\n ● Delivering center's message to the residents of remote areas by facilitating scientific convoys."))
            list.append(ScitechInfo(text: "Objectives", img: "Screen Shot 2019-01-15 at 6.55.44 AM", dis: "Address: Kingdom of Saudi Arabia \n Region: Easter province - Khobar - Corniche \n P.B 1914 – zip code 31952\n Phone number: 00966-13-8967777\n Fax: 00966-13-8967778 \n email :info@scitech.edu.sa"))
        }else if(languageIsItAr){
             list.append(ScitechInfo(text: "الاتصال بنا", img: "Screen Shot 2019-01-15 at 6.55.44 AM", dis: "العنوان : \n المنطقة : الشرقية - الخبر - الكورنيش \n ص.ب. 1914 - الرمز البريدي 31952\n هاتف: 8967777-13-966+\n فاكس: 8967778-13-966+ \n البريد الالكتروني: info@scitech.edu.sa"))
               list.append(ScitechInfo(text: "اهداف المركز", img: "Screen Shot 2019-01-15 at 6.55.44 AM", dis: "● توسـيع الأفـق العـلمي والثقافي لزوارالمركز في مجـالات العلوم والتقنية.\n ●  تبسيط الأفكار والموضوعـات العلمية وجعلها شيقة وممتعة للجميع.\n ● تنميـة حـب الإسـتطـلاع والـقـراءة والإستكشاف في المجالات العلمية. \n ● مسـاعدة الزوار على تطوير أسـالـيب التفكير والتحليـل العـلمي وجعلهـا أمرا طبيعيا في حياتهم.\n ●  تنميـة إدراك وتـقـديـر الــزوار لـــدور العلوم والتقنية في حياتهم اليومية.\n ● ربـط بـرامـج ومعـروضـات المركــز بمناهج التعليم في المملكة.\n ● تنظيم معارض مؤقتة في مجالات العلوم والتقنية مثل الكتب العلمية والحاسب الآلي والإتصالات وغيرها. \n ●إيصال رســـالة المـركـز إلى ســكـان المناطق البعيدة نسبيا."))
             list.append(ScitechInfo(text: "رسالة المركز", img: "Screen Shot 2019-01-15 at 6.55.44 AM", dis: "نشر مبادئ العلوم و إبداعات التقنية عن طريق عرضها بأساليب حديثة و ممتعة لأفراد المجتمع، و خاصة الناشئة من أجل توسيع آفاقهم العلمية و تشجيعهم على الاهتمام بمجالات العلوم و التقنية، ليصبحوا قادرين على مواكبة المستجدات العلمية و مؤهلين للرقي بأنفسهم و وطنهم إلى مستويات متميزة."))
            list.append(ScitechInfo(text: "نبذة عن سايتك", img: "Screen Shot 2019-01-15 at 6.55.30 AM", dis: "مركز سلطان بن عبد العزيز للعلوم والتقنية (سايتك) هو أحد مشاريع مؤسسة الأمير سلطان بن عبد العزيز آل سعود الخيرية ولقد جاءت فكرة إنشاء المركز عام 2000م حيث أمر الأمير سلطان بن عبد العزيز (رحمه الله) بإنشاء مركز علمي على غرار أحدث المراكز العلمية في العالم ليخدم فئة الطلبة والباحثين في مجالات العلوم والتقنية وجميع فئات المجتمع.\nنظراً لنظرة الأمير سلطان بن عبد العزيز (رحمه الله) في إهداء المركز إلى جهة تعنى بالأمور العلمية والتقنية فقد أمر بإهداءه إلى جامعة الملك فهد للبترول والمعادن في عام 2006م ، ليصبح بذلك أحد المراكز الفاعله في خدمة وتوعية المجتمع .\nيقع المركز على كورنيش مدينة الخبر على أرض مساحتها 21.700متر مربع و مساحة المبنى 14.100متر مربع صمم و نفذ على غرار أحدث المركز العلمية ويشتمل على ( 7 ) قاعات عرض رئيسية تتناول مختلف العلوم و التقنية ، تضم أكثر من (350) معروضة علمية ، و القبة العلمية \" IMAX \"، المرصد الفلكي، الوحدة التعليمية ، قاعة المؤتمرات، قاعة المعارض المؤقتة، مرافق إدارية وخدمات. يهدف المركز بصورة أساسية إلى تثقيف أفراد المجتمع-خاصة الناشئة - بمبادئ العلوم وتطبيقاتها و شرحها و تبسيطها من خلال عرضها بأسلوب تفاعلي شيق يعتمد على التعليم بالترفيه/ التعليم بالتجربة و المشاهدة."))
           
         
           
        }
        
        
    }
    
    
}
