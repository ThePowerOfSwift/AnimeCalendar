//
//  ViewController.swift
//  AnimeCalendar
//
//  Created by Lucy Zhang on 9/16/17.
//  Copyright © 2017 Lucy Zhang. All rights reserved.
//

import Cocoa
import AppKit
import EventKit

class ViewController: NSViewController {
    
    let calendar = Calendar.current
    
    var days = [Int]()

    @IBOutlet weak var containerView: NSView!
    
    @IBOutlet weak var outlineView: NSOutlineView!
    
    lazy var animeEventController =
        {
            return AnimeEventController(window: NSApp.windows.first!)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    func daysInMonth() -> Double{
        let today = Date()
        let year = calendar.component(.year, from: today)
        let month = calendar.component(.month, from: today)
        var components = DateComponents()
        components.year = year
        components.month = month
        let newDate = calendar.date(from: components)
        let range = calendar.range(of: .day, in: .month, for: newDate!)!
        let numDays = range.count
        self.days = Array(1...numDays)
        return Double(numDays)
    }
    
}

extension ViewController:NSOutlineViewDataSource
{
    func outlineView(_ outlineView: NSOutlineView, numberOfChildrenOfItem item: Any?) -> Int {
        print(item)
        if let calendarData = item as? [EKCalendar]
        {
            return calendarData.count
        }
        // the number if calendars
        return self.animeEventController.sourceToCalendars().keys.count
    }
    
    func outlineView(_ outlineView: NSOutlineView, child index: Int, ofItem item: Any?) -> Any {
        print(item)
        if let calendars = item as? [EKCalendar]
        {
            return calendars[index].title
        }
        else
        {
            let source = self.animeEventController.sources[index]
            print(source.title)
            print(self.animeEventController.sourceToCalendars()[source.title])
            return self.animeEventController.sourceToCalendars()[source.title]
        }
        //return item
    }
    
    func outlineView(_ outlineView: NSOutlineView, isItemExpandable item: Any) -> Bool {
        return ((item as? [EKCalendar]) == nil)
    }
}

extension ViewController:NSOutlineViewDelegate
{
    func outlineView(_ outlineView: NSOutlineView, viewFor tableColumn: NSTableColumn?, item: Any) -> NSView? {
        var cellView:NSView!
        
        cellView = outlineView.make(withIdentifier: "AnimeCalendar", owner: nil)
        
        if let entry = item as? String{
            (cellView as? NSTableCellView)?.textField?.stringValue = entry
        }
        else if let entry = item as? [EKCalendar]
        {
            (cellView as? NSTableCellView)?.textField?.stringValue = entry[0].source.title
        }
        
        return cellView
    }
}



