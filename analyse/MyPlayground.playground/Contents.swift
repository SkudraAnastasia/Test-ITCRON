/*1. Что произойдет при выполнении кода. Почему?
Что можно исправить и улучшить?
 
struct Employee {
    let name: String?
    let age: Int
    let gender: String
    let salary: Int
    let isActive: String
    }

let employees = [
    Employee(name: "Алексей", age: 25, gender: "Мужчина",
salary: 150000, isActive: "Да"),
    Employee(name: nil, age: 30, gender: "Женщина", salary:
180000, isActive: "Да"),
    Employee(name: "Мария", age: 22, gender: "Женщина", salary:
90000, isActive: "Нет"),
    Employee(name: "Иван", age: 28, gender: "Мужчина", salary:
170000, isActive: "Да"),
    Employee(name: "Екатерина", age: 35, gender: "Женщина",
salary: 210000, isActive: "Нет")
    ]

func printEmployees() {
    for employee in employees {
        print(employee.name!)
    }
}
printEmployees()


 1) Код скомпилируется, однако выдаст ошибку из за строки  print(employee.name!)
 Тут принудительное извлечение типа Optinal, при этом у одного элемента name = nil. Принудительное извлечнеие допустимо только если значение точно не будет nil. Делать так не рекомендуется, лучше всегда использовать безопасное извлечение Optional
 
 Если имя может отсутствовать, необходимо указывать дефолтное значение:  print(employee.name ?? "Не указано")
 
 Я бы не стала делать имя опциональным значением, т.к. по логике список сотрудников должен быть с именами самих сотрудников.
 
 2) необходимо установить допустимые значения для Age и Salary (например, они не должны быть отрицательными)
 
 3) gender необходимо вынести в отдельный enum, чтоб не допустить случайных строк(т.к. тут всего 2 кейса)
 
 4) isActive - это флаг, он обязательно должен быть типа Bool
 
Код я бы исправила следующим образом:
 */

struct Employee {
    let name: String
    let age: Int
    let gender: String
    let salary: Int
    let isActive: Bool
}

let employees = [
    Employee(name: "Алексей", age: 25, gender: "Мужчина", salary: 150000, isActive: true),
    Employee(name: "Анна", age: 30, gender: "Женщина", salary: 180000, isActive: true),
    Employee(name: "Мария", age: 22, gender: "Женщина", salary: 90000, isActive: false),
    Employee(name: "Иван", age: 28, gender: "Мужчина", salary: 170000, isActive: true),
    Employee(name: "Екатерина", age: 35, gender: "Женщина", salary: 210000, isActive: false)
]

func printEmployees(_ employees: [Employee]) {
    for employee in employees {
        if employee.age > 18 && employee.salary > 0 {
            print(employee.name)
        } else {
            print("Неверно указаны данные")
        }
    }
}

printEmployees(employees)
