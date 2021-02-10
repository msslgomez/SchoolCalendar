//
//  ViewController.swift
//  UnadecaAgenda
//
//  Created by ISC Devolpers on 26/1/21.
//

import UIKit

class ViewController: UIViewController, FSCalendarDataSource, FSCalendarDelegate, FSCalendarDelegateAppearance {
    
    @IBOutlet weak var EventsTableView: UITableView!
    @IBOutlet weak var Calendar: FSCalendar!
    
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    var items:[Event] = []
    var downloaded:Bool = false
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        initialSetup()
        
        getEvents()
        
        if !downloaded {
            downloadEvents()
        }
        
        print(downloaded)
    }
    
    func initialSetup() {
        //calendar
     
        Calendar.dataSource = self
        Calendar.delegate = self

        
        //tableview
        EventsTableView.delegate = self
        EventsTableView.dataSource = self
        self.EventsTableView.rowHeight = UITableView.automaticDimension
        self.EventsTableView.estimatedRowHeight = 40.0
        
        
    }
    
    func getEvents(){
        do {
            self.items = try context.fetch(Event.fetchRequest())
            
            DispatchQueue.main.async {
                self.EventsTableView.reloadData()
            }
            
        }
        catch {
            
        }
    }
    

    func downloadEvents() {
        let UrlString = "https://calendario.unadeca.ac.cr/data"
        let url = URL(string: UrlString)

        guard url != nil else {
            return
        }

        let session = URLSession.shared

        var request = URLRequest(url: url!)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("application/json", forHTTPHeaderField: "Accept")

        let dataTask = session.dataTask(with: request) { (data, response, error) in
            //check for errors
            if error == nil && data != nil {
                //parse JSON
                let decoder = JSONDecoder()

                do {
                    let events = try decoder.decode(CalEvents.self, from: data!)
                    
                    for event in events.events ?? []  {
                        //create new coredata event
                        let newEvent = Event(context: self.context)
                        newEvent.id = Int64(event.id)
                        newEvent.init_date = event.init_date
                        newEvent.end_date = event.end_date
                        newEvent.title = event.title
                        if event.description == nil {
                            newEvent.event_description = ""
                        }
                        newEvent.event_description = event.description
                        
                        //save cordata event
                        do {
                            try self.context.save()
                            self.downloaded = true
                        }
                        catch {
                            
                        }
                    }
                }
                catch {
                    print("Error in JSON Parsing: \(error)")
                    print(data!)
                }

            }
        }

        //make the api call
        dataTask.resume()

    }
    
    func dateToDay(date:Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "es_CR")
        formatter.dateFormat = "dd"
        
        return formatter.string(from: date)
    }

}

extension ViewController: UITableViewDataSource, UITableViewDelegate {

    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }

    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let event = items[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "EventCell") as! EventCell
        
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "es_CR")
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        let init_date = formatter.date(from: event.init_date!)
        let end_date = formatter.date(from: event.end_date!)
        
        var date:String
        
        if init_date == end_date {
            date = dateToDay(date: init_date!)
        } else {
            date = dateToDay(date: init_date!) + " - " + dateToDay(date: end_date!)
        }
        
        cell.setEvent(title: event.title!, date: date)
        
        print(event)
        

        return cell
    }
}
