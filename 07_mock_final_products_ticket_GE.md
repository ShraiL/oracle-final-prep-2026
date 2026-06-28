# Dummy Final Prüfung - Market/Products

**Regel:** Erst `06_mock_final_products_schema.sql` mit **F5** ausführen. Danach diese 10 Aufgaben nacheinander lösen.

## N1 - ALTER TABLE + Data Cleansing

ცხრილ `PRODUCTS`-ს დაამატე ველები:

```sql
product_code VARCHAR2(80)
code_prefix VARCHAR2(30)
```

შემდეგ `product_code` შეავსე ფორმატით:

```sql
lower(product_name) || '-' || product_id
```

`code_prefix` სვეტში ჩაწერე მხოლოდ ტექსტი `-` სიმბოლომდე.

## N2 - UNIQUE Constraint

ცხრილ `SALES_RAW`-ში უზრუნველყავი, რომ შემდეგი კომბინაცია იყოს უნიკალური:

```sql
customer_id, product_id, sale_date
```

დაამატე `UNIQUE` constraint ან unique index.

თუ duplicate ჩანაწერები არსებობს, ჯერ გაასუფთავე.

## N3 - GROUP BY + HAVING

`category_id`-ის მიხედვით გამოიტანე:

```text
category_id
product_count
total_price
avg_price
```

აჩვენე მხოლოდ ის კატეგორიები, სადაც პროდუქტების რაოდენობა არის მინიმუმ `3`.

დაალაგე `total_price`-ის კლებადობით.

## N4 - Correlated Subquery

გამოიტანე თითოეულ კატეგორიაში ყველაზე ძვირი პროდუქტი/პროდუქტები:

```text
category_id
product_name
price
```

## N5 - Self Join

ცხრილ `EMP`-ში self join-ის გამოყენებით გამოიტანე:

```text
employee_name
manager_name
manager_job
```

აჩვენე მხოლოდ ის თანამშრომლები, რომლებსაც მენეჯერი ჰყავთ.

## N6 - Non-Equi Join

ცხრილ `PRODUCTS`-ში თითოეულ პროდუქტს მოუძებნე price grade ცხრილ `PRICE_GRADE`-დან.

პროდუქტის ფასი უნდა მოხვდეს:

```sql
min_price .. max_price
```

გამოიტანე:

```text
product_name
price
grade
price_above_min
```

სადაც:

```sql
price_above_min = price - min_price
```

აჩვენე მხოლოდ grade `2`, `3`, `4`.

დაალაგე ჯერ grade ზრდადობით, შემდეგ price კლებადობით.

## N7 - NOT EXISTS

გამოიტანე ის კატეგორიები:

```text
category_id
category_name
```

სადაც არც ერთი პროდუქტი არ არის რეგისტრირებული.

## N8 - Conditional INSERT + UPDATE without MERGE

ცხრილ `CATEGORIES`-ზე შეასრულე შემდეგი:

თუ კატეგორია `category_name = 'ELECTRONICS'` არ არსებობს, ჩასვი:

```sql
(90, 'ELECTRONICS', 'ACTIVE')
```

თუ `ELECTRONICS` უკვე არსებობს, განაახლე მისი `status` მნიშვნელობა `ACTIVE`-ზე.

გამოიყენე:

```sql
INSERT ... SELECT ... WHERE NOT EXISTS
UPDATE ... WHERE EXISTS
```

არ გამოიყენო `MERGE`.

## N9 - User + Role + GRANT

შექმენი მომხმარებელი:

```text
market_user
```

პაროლით:

```text
Market#123
```

მომხმარებელს უნდა შეეძლოს login.

მას უნდა ჰქონდეს მხოლოდ `SELECT` უფლებები ცხრილებზე:

```text
PRODUCTS
CATEGORIES
SALES_RAW
```

არ მისცე `CREATE TABLE` უფლება.

დამატებით შექმენი role:

```text
market_reader
```

ამ role-ს მიანიჭე `SELECT` უფლებები ზემოთ ჩამოთვლილ ცხრილებზე და შემდეგ role მიანიჭე `market_user`-ს.

## N10 - Normalization

მოცემულია ცხრილი:

```text
COURSE_RAW
sid | sname | course_code | course_name | teacher_name | teacher_phone | semester
```

მაგალითები:

```text
1 | Ana K.  | DB101 | Databases I | N.Beridze | 555-100 | 2026F
1 | Ana K.  | SQL01 | SQL Basics  | N.Beridze | 555-100 | 2026F
2 | Gio M.  | DB101 | Databases I | N.Beridze | 555-100 | 2026F
3 | Nino T. | JV100 | Java Intro  | L.Dvali   | 555-200 | 2026F
3 | Nino T. | DB101 | Databases I | N.Beridze | 555-100 | 2026F
4 | Dato R. | WEB10 | Web Basics  | L.Dvali   | 555-200 | 2026F
4 | Dato R. | SQL01 | SQL Basics  | N.Beridze | 555-100 | 2026F
```

მიუთითე:

```text
1. რომელ normal form-შია ცხრილი
2. Functional Dependencies
3. რა პრობლემებია ცხრილში
4. დაშალე ცხრილი 4NF-მდე
```

