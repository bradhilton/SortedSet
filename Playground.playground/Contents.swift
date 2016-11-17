import UIKit
import SortedSet
import PlaygroundSupport

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
                               style: .plain,
                               target: self,
                               action: #selector(performTransition))
    }
    
    func performTransition() {
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
            animate(diff: SortedSet.diff(oldValue, people))
        }
    }
    
    func animate(diff: Diff) {
        CATransaction.begin()
        CATransaction.setCompletionBlock {
            self.tableView.reloadData()
        }
        tableView.beginUpdates()
        tableView.insertRows(at: diff.inserts.map { IndexPath(row: $0, section: 0) }, with: .top)
        tableView.deleteRows(at: diff.deletes.map { IndexPath(row: $0, section: 0) }, with: .top)
        for move in diff.moves {
            tableView.moveRow(at: IndexPath(row: move.from, section: 0), to: IndexPath(row: move.to, section: 0))
        }
        tableView.endUpdates()
        CATransaction.commit()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        navigationItem.rightBarButtonItem = transitionItem()
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let person = people[indexPath.row]
        cell.textLabel?.text = "Age: \(person.age)   Hash Value: \(person.hashValue)"
        return cell
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    
}

let controller = TableViewController()

PlaygroundPage.current.liveView = UINavigationController(rootViewController: controller)
