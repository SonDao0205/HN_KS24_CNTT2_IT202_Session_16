DROP DATABASE IF EXISTS SS16;
CREATE DATABASE SS16;
USE SS16;

-- Câu 2 - Tạo bảng
-- 2.1 Viết câu lệnh tạo cơ sở dữ liệu tên quanlybanhang .
-- 2.2 Viết câu lệnh tạo 5 bảng theo mô tả ở trên.
CREATE TABLE Customers(
	customer_id INT PRIMARY KEY AUTO_INCREMENT ,
	customer_name varchar(100) NOT NULL,
	phone varchar(20) NOT NULL UNIQUE,
	address varchar(255)
);

CREATE TABLE Products(
	product_id INT PRIMARY KEY AUTO_INCREMENT ,
    product_name VARCHAR(255) NOT NULL UNIQUE,
    price decimal(10,2) NOT NULL,
    quantity INT NOT NULL CHECK(quantity >= 0),
    category varchar(50) NOT NULL
);

CREATE TABLE Employees(
	employee_id INT PRIMARY KEY AUTO_INCREMENT ,
    employee_name VARCHAR(100) NOT NULL,
    birthday DATE,
    position VARCHAR(50) NOT NULL,
    salary decimal(10,2) NOT NULL,
    revenue decimal(10,2) DEFAULT 0
);

CREATE TABLE Orders(
    order_id INT PRIMARY KEY AUTO_INCREMENT ,
    customer_id INT,
    employee_id INT,
    FOREIGN KEY(customer_id) REFERENCES Customers(customer_id),
    FOREIGN KEY(employee_id) REFERENCES Employees(employee_id),
    order_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    total_amount decimal(10,2) DEFAULT 0
);

CREATE TABLE OrderDetails(
	order_detail_id INT PRIMARY KEY AUTO_INCREMENT ,
    order_id INT,
    product_id INT,
    FOREIGN KEY(order_id) REFERENCES Orders(order_id),
    FOREIGN KEY(product_id) REFERENCES Products(product_id),
    quantity INT NOT NULL CHECK(quantity > 0),
    unit_price DECIMAL(10,2) NOT NULL
);

-- Câu 3 - Chỉnh sửa cấu trúc bảng
-- 3.1 Thêm cột email có kiểu dữ liệu varchar(100) not null unique vào bảng
-- Customers
ALTER TABLE Customers
ADD email VARCHAR(100) NOT NULL UNIQUE;
-- 3.2 Xóa cột ngày sinh ra khỏi bảng Employees
ALTER TABLE Employees
DROP COLUMN birthday;

-- PHẦN 2: TRUY VẤN DỮ LIỆU
-- Câu 4 - Chèn dữ liệu
-- Viết câu lệnh chèn dữ liệu vào bảng (mỗi bảng ít nhất 5 bản ghi phù hợp)
INSERT INTO Customers(customer_name, phone, address, email) VALUES
('Nguyễn Văn An', '0901111111', 'Hà Nội', 'an@gmail.com'),
('Trần Thị Bình', '0902222222', 'Hải Phòng', 'binh@gmail.com'),
('Lê Văn Cường', '0903333333', 'Đà Nẵng', 'cuong@gmail.com'),
('Phạm Thị Dung', '0904444444', 'Huế', 'dung@gmail.com'),
('Hoàng Văn Em', '0905555555', 'TP.HCM', 'em@gmail.com');

INSERT INTO Products(product_name, price, quantity, category) VALUES
('Laptop Asus', 18000000, 10, 'Điện tử'),
('Chuột Logitech', 350000, 50, 'Phụ kiện'),
('Bàn phím cơ', 1200000, 30, 'Phụ kiện'),
('Màn hình LG', 4200000, 20, 'Điện tử'),
('Tai nghe Sony', 2000000, 25, 'Âm thanh');

INSERT INTO Employees(employee_name, position, salary, revenue) VALUES
('Nguyễn Thị Hoa', 'Bán hàng', 8000000, 0),
('Trần Văn Long', 'Quản lý', 15000000, 0),
('Phạm Minh Tuấn', 'Thu ngân', 7000000, 0),
('Lê Thị Mai', 'Bán hàng', 8500000, 0),
('Hoàng Quốc Huy', 'Kho', 9000000, 0);

INSERT INTO Orders(customer_id, employee_id, total_amount) VALUES
(1, 1, 35000000),
(2, 2, 42000000),
(3, 1, 24000000),
(4, 3, 12000000),
(5, 4, 17500000);


-- Order 1
INSERT INTO OrderDetails(order_id, product_id, quantity, unit_price) VALUES
(1, 2, 100, 350000),   -- Chuột Logitech: 100 cái
(1, 3, 10, 1200000);  -- Bàn phím cơ: 10 cái
-- Tổng: 100*350k + 10*1.2tr = 35,000,000

-- Order 2
INSERT INTO OrderDetails(order_id, product_id, quantity, unit_price) VALUES
(2, 4, 10, 4200000);  -- 10 màn hình LG = 42,000,000

-- Order 3
INSERT INTO OrderDetails(order_id, product_id, quantity, unit_price) VALUES
(3, 5, 12, 2000000);  -- 12 tai nghe Sony = 24,000,000

-- Order 4
INSERT INTO OrderDetails(order_id, product_id, quantity, unit_price) VALUES
(4, 3, 10, 1200000);  -- 10 bàn phím = 12,000,000

-- Order 5
INSERT INTO OrderDetails(order_id, product_id, quantity, unit_price) VALUES
(5, 2, 50, 350000);   -- 50 chuột = 17,500,000


-- Câu 5 - Truy vấn cơ bản
-- 5.1 Lấy danh sách tất cả khách hàng từ bảng Customers. Thông tin gồm : mã khách
-- hàng, tên khách hàng, email, số điện thoại và địa chỉ
SELECT customer_id 'Mã khách hàng', customer_name 'Tên khách hàng', email, phone 'Số điện thoại', address 'Địa chỉ'
FROM Customers;
-- 5.2 Sửa thông tin của sản phẩm có product_id = 1 theo yêu cầu : product_name=
-- “Laptop Dell XPS” và price = 99.99
UPDATE Products
SET product_name = 'Laptop Dell XPS', price = 99.99
WHERE product_id = 1;
-- 5.3 Lấy thông tin những đơn đặt hàng gồm : mã đơn hàng, tên khách hàng, tên nhân
-- viên, tổng tiền và ngày đặt hàng.
SELECT o.order_id 'Mã đơn hàng', c.customer_name 'Tên khách hàng', e.employee_name 'Tên nhân viên', total_amount 'Tổng tiền', order_date 'Ngày đặt hàng'
FROM Orders o
JOIN Customers c ON c.customer_id = o.customer_id
JOIN Employees e ON e.employee_id = o.employee_id;

-- Câu 6 - Truy vấn đầy đủ
-- 6.1 Đếm số lượng đơn hàng của mỗi khách hàng. Thông tin gồm : mã khách hàng, tên
-- khách hàng, tổng số đơn
SELECT o.customer_id 'Mã khách hàng', c.customer_name 'Tên khách hàng', COUNT(o.customer_id) 'Tổng số đơn'
FROM Orders o
JOIN Customers c ON c.customer_id = o.customer_id
GROUP BY o.customer_id;

-- 6.2 Thống kê tổng doanh thu của từng nhân viên trong năm hiện tại. Thông tin gồm :
-- mã nhân viên, tên nhân viên, doanh thu
SELECT o.employee_id 'Mã nhân viên', e.employee_name 'Tên nhân viên', SUM(total_amount) 'Doanh thu'
FROM Orders o
JOIN Employees e ON e.employee_id = o.employee_id
GROUP BY o.employee_id;

-- 6.3 Thống kê những sản phẩm có số lượng đặt hàng lớn hơn 100 trong tháng hiện tại.
-- Thông tin gồm : mã sản phẩm, tên sản phẩm, số lượt đặt và sắp xếp theo số lượng
-- giảm dần
SELECT p.product_id 'Mã sản phẩm' , p.product_name 'Tên sản phẩm', SUM(od.quantity) 'Số lượng đặt'
FROM OrderDetails od
JOIN Products p ON od.product_id = p.product_id
GROUP BY od.product_id
HAVING SUM(od.quantity) > 100;

-- Câu 7 - Truy vấn nâng cao
-- 7.1 Lấy danh sách khách hàng chưa từng đặt hàng. Thông tin gồm : mã khách hàng và
-- tên khách hàng
SELECT c.customer_id, c.customer_name
FROM Customers c
LEFT JOIN Orders o ON c.customer_id = o.customer_id
WHERE o.order_id IS NULL;

-- 7.2 Lấy danh sách sản phẩm có giá cao hơn giá trung bình của tất cả sản phẩm
SELECT *
FROM Products
WHERE price > (
	SELECT AVG(price) FROM Products
);
-- 7.3 Tìm những khách hàng có mức chi tiêu cao nhất. Thông tin gồm : mã khách hàng,
-- tên khách hàng và tổng chi tiêu .(Nếu các khách hàng có cùng mức chi tiêu thì lấy hết)
SELECT 
    c.customer_id,
    c.customer_name,
    SUM(o.total_amount) AS 'Tổng chi tiêu'
FROM Orders o
JOIN Customers c ON o.customer_id = c.customer_id
GROUP BY c.customer_id, c.customer_name
HAVING SUM(o.total_amount) = (
    SELECT MAX(total)
    FROM (
        SELECT SUM(total_amount) AS total
        FROM Orders
        GROUP BY customer_id
    ) AS tempSub
);

-- Câu 8 - Tạo view
-- 8.1 Tạo view có tên view_order_list hiển thị thông tin đơn hàng gồm : mã đơn hàng,
-- tên khách hàng, tên nhân viên, tổng tiền và ngày đặt. Các bản ghi sắp xếp theo thứ tự
-- ngày đặt mới nhất
CREATE VIEW view_order_list AS
SELECT o.order_id 'Mã đơn hàng', c.customer_name 'Tên khách hàng', e.employee_name 'Tên nhân viên', total_amount 'Tổng tiền', order_date 'Ngày đặt hàng'
FROM Orders o
JOIN Customers c ON c.customer_id = o.customer_id
JOIN Employees e ON e.employee_id = o.employee_id
ORDER BY order_date DESC;

SELECT *
FROM view_order_list;

-- 8.2 Tạo view có tên view_order_detail_product hiển thị chi tiết đơn hàng gồm : Mã
-- chi tiết đơn hàng, tên sản phẩm, số lượng và giá tại thời điểm mua. Thông tin sắp xếp
-- theo số lượng giảm dần
CREATE VIEW view_order_detail_product AS
SELECT od.order_detail_id, p.product_name, od.quantity, od.unit_price
FROM OrderDetails od
JOIN Orders o ON o.order_id = od.order_id
JOIN Products p ON p.product_id = od.product_id
ORDER BY od.quantity DESC;

SELECT *
FROM view_order_detail_product;

-- Câu 9 - Tạo thủ tục lưu trữ
-- 9.1 Tạo thủ tục có tên proc_insert_employee nhận vào các thông tin cần thiết (trừ mã
-- nhân viên và tổng doanh thu) , thực hiện thêm mới dữ liệu vào bảng nhân viên và trả
-- về mã nhân viên vừa mới thêm.
DELIMITER $$
CREATE PROCEDURE proc_insert_employee(p_employee_name VARCHAR(100),p_position VARCHAR(50),p_salary decimal(10,2), OUT out_employee_id INT)
BEGIN

	INSERT INTO Employees(employee_name,position,salary) VALUES
    (p_employee_name,p_position,p_salary);

	SET out_employee_id = LAST_INSERT_ID();
END $$
DELIMITER ;

CALL proc_insert_employee('Nguyễn Văn Bình', 'Bán hàng', 9000000, @new_id);
SELECT @new_id AS 'Mã nhân viên mới';

-- 9.2 Tạo thủ tục có tên proc_get_orderdetails lọc những chi tiết đơn hàng dựa theo
-- mã đặt hàng.

DELIMITER $$
CREATE PROCEDURE proc_get_orderdetails(p_order_id INT)
BEGIN
	SELECT *
    FROM OrderDetails
    WHERE order_id = p_order_id;
END $$
DELIMITER ;

CALL proc_get_orderdetails(1);

-- 9.3 Tạo thủ tục có tên proc_cal_total_amount_by_order nhận vào tham số là mã
-- đơn hàng và trả về số lượng loại sản phẩm trong đơn hàng đó.
DELIMITER $$
CREATE PROCEDURE proc_cal_total_amount_by_order(p_order_id INT)
BEGIN

	SELECT COUNT(product_id) 'Số lượng loại sản phẩm trong đơn hàng'
    FROM OrderDetails
    WHERE order_id = p_order_id;

END $$
DELIMITER ;

CALL proc_cal_total_amount_by_order(1);

-- Câu 10 - Tạo trigger
-- Tạo trigger có tên trigger_after_insert_order_details để tự động cập nhật số lượng
-- sản phẩm trong kho mỗi khi thêm một chi tiết đơn hàng mới. Nếu số lượng trong kho
-- không đủ thì ném ra thông báo lỗi “Số lượng sản phẩm trong kho không đủ” và hủy
-- thao tác chèn.
DELIMITER $$
CREATE TRIGGER trigger_after_insert_order_details
AFTER INSERT
ON OrderDetails
FOR EACH ROW
BEGIN
	DECLARE current_stock INT;
    
    SELECT quantity INTO current_stock
    FROM Products
    WHERE product_id = NEW.product_id;

	IF current_stock < new.quantity THEN
		SIGNAL SQLSTATE '45000' 
        SET MESSAGE_TEXT = 'Số lượng sản phẩm trong kho không đủ';
	ELSE 
		UPDATE Products
        SET quantity = quantity - NEW.quantity
        WHERE product_id = NEW.product_id;
	END IF;
END $$
DELIMITER ;


-- Câu 11 - Quản lý transaction
-- Tạo một thủ tục có tên proc_insert_order_details nhận vào tham số là mã đơn hàng,
-- mã sản phẩm, số lượng và giá sản phẩm. Sử dụng transaction thực hiện các yêu cầu
-- sau :
-- Kiểm tra nếu mã hóa đơn không tồn tại trong bảng order thì ném ra thông báo
-- lỗi “không tồn tại mã hóa đơn”.
-- Chèn dữ liệu vào bảng order_details
-- Cập nhật tổng tiền của đơn hàng ở bảng Orders
-- Nếu như có bất cứ lỗi nào sinh ra, rollback lại Transaction
-- Câu 11 - Quản lý transaction
DELIMITER $$
CREATE PROCEDURE proc_insert_order_details(
    IN p_order_id INT, 
    IN p_product_id INT, 
    IN p_quantity INT, 
    IN p_unit_price DECIMAL(10,2)
)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Lỗi trong quá trình xử lý transaction, đã rollback';
    END;
    START TRANSACTION;
        IF NOT EXISTS (SELECT 1 FROM Orders WHERE order_id = p_order_id) THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Không tồn tại mã hóa đơn';
        END IF;

        INSERT INTO OrderDetails(order_id, product_id, quantity, unit_price)
        VALUES (p_order_id, p_product_id, p_quantity, p_unit_price);
        
        UPDATE Orders
        SET total_amount = total_amount + (p_quantity * p_unit_price)
        WHERE order_id = p_order_id;

    COMMIT;
    
END $$
DELIMITER ;
