import UIKit
import SortedSet
import XCPlayground

struct Person : Hashable, Comparable {
    var age: Int
    let hashValue: Int
}

func ==(lhs: Person, rhs: Person) -> Bool {
    return lhs.hashValue == rhs.hashValue
}

func <(lhs: Person, rhs: Person) -> Bool {
    return lhs.age < rhs.age
}

class TableViewController : UITableViewController {
    
    func transitionItem() -> UIBarButtonItem {
        return UIBarButtonItem(title: "Transition",
                               style: .Plain,
                               target: self,
                               action: #selector(transition))
    }
    
    func transition() {
        people = alternate
    }
    
    var alternate: SortedSet<Person> = [
        Person(age: 17, hashValue: 7),
        Person(age: 18, hashValue: 4),
        Person(age: 21, hashValue: 1),
        Person(age: 24, hashValue: 0),
        Person(age: 25, hashValue: 6),
        Person(age: 31, hashValue: 2),
        Person(age: 32, hashValue: 5),
    ]
    
    var people: SortedSet<Person> = [
            Person(age: 16, hashValue: 0),
            Person(age: 22, hashValue: 1),
            Person(age: 23, hashValue: 2),
            Person(age: 28, hashValue: 3),
            Person(age: 30, hashValue: 4),
        ]
        
    {
        didSet {
            alternate = oldValue
            animateDiff(SortedSet.diff(oldValue, people))
        }
    }
    
    func animateDiff(diff: Diff) {
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            self.tableView.reloadData()
        }
        tableView.beginUpdates()
        tableView.insertRowsAtIndexPaths(diff.inserts.map { .init(forRow: $0, inSection: 0) }, withRowAnimation: .Top)
        tableView.deleteRowsAtIndexPaths(diff.deletes.map { .init(forRow: $0, inSection: 0) }, withRowAnimation: .Top)
        for move in diff.moves {
            tableView.moveRowAtIndexPath(.init(forRow: move.from, inSection: 0),
                toIndexPath: .init(forRow: move.to, inSection: 0))
        }
        tableView.endUpdates()
        CATransaction.commit()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        navigationItem.rightBarButtonItem = transitionItem()
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Cell", forIndexPath: indexPath)
        let person = people[indexPath.row]
        cell.textLabel?.text = "Age: \(person.age)   ID: \(person.hashValue)"
        return cell
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    
}

let controller = TableViewController()

XCPlaygroundPage.currentPage.liveView = UINavigationController(rootViewController: controller)
