-- 1) Retrieve all books in the "Fiction" genre:
select
  *
from
  bookstore.books
where
  "Genre" = 'Fiction';

-- --2)Find books published after the year 1950:
select
  *
from
  bookstore.books
where
  "Published_Year" > 1950;

-- 3) List all customers from the Canada:
select
  *
from
  bookstore.customers
where
  "Country" = 'Canada';

--4) Show orders placed in November 2023:
select
  *
from
  bookstore.orders
where
  "Order_Date" between '2023-11-01' and '2023-11-30';

-- --5) Retrieve the total stock of books available:
select
  sum("Stock") as total_stock
from
  bookstore.books;

-- --6) Find the details of the most expensive book:
select
  *
from
  bookstore.books
order by
  "Price" desc
limit
  1;

-- --7) Show all customers who ordered more than 1 quantity of a book:
select
  *
from
  bookstore.orders
where
  "Quantity" > 1;

-- 8) Retrieve all orders where the total amount exceeds $20:
select
  *
from
  bookstore.orders
where
  "Total_Amount" > 20;

-- 9) List all genres available in the Books table:
select distinct
  "Genre"
from
  bookstore.books;

-- -10) Find the book with the lowest stock:
select
  *
from
  bookstore.books
order by
  "Stock" asc
limit
  1;

-- 11) Calculate the total revenue generated from all orders:
select
  sum("Total_Amount") as total_revenue
from
  bookstore.orders;

-- -- Advance Questions:
-- -1) Retrieve the total number of books sold for each genre:
select
  b."Genre",
  sum(o."Quantity") as total_sold_books
from
  bookstore.books b
  left join bookstore.orders o on o."Book_ID" = b."Book_ID"
group by
  1;

-- 2) Find the average price of books in the "Fantasy" genre:
select
  b."Genre",
  avg(b."Price") as avg_price
from
  bookstore.books b
where
  b."Genre" = 'Fantasy'
group by
  b."Genre";

-- 3) List customers who have placed at least 2 orders:
select
  o."Customer_ID",
  count(o."Order_ID") as total_order
from
  bookstore.orders o
group by
  1
having
  count(o."Order_ID") >= 2;

-- 4) Find the most frequently ordered book:
select
  o."Book_ID",
  b."Title",
  b."Genre",
  count(o."Order_ID") as total_order
from
  bookstore.orders o
  left join bookstore.books b on o."Book_ID" = b."Book_ID"
group by
  1,
  2,
  3
order by
  total_order desc
limit
  1;

-- 5) Show the top 3 most expensive books of 'Fantasy' Genre:
select
  *
from
  bookstore.books
where
  "Genre" = 'Fantasy'
order by
  "Price" desc
limit
  3;

-- 6) Retrieve the total quantity of books sold by each author:
select
  *
from
  (
    select
      b."Author",
      sum(o."Quantity") as total_sold_books
    from
      bookstore.books b
      left join bookstore.orders o on b."Book_ID" = o."Book_ID"
    group by
      1
    order by
      total_sold_books desc
  ) as ct
where
  ct is not null;

-- --7) List the cities where customers who spent over $30 are located:
select distinct
  c."City",
  o."Total_Amount"
from
  bookstore.orders o
  left join bookstore.customers c on o."Customer_ID" = c."Customer_ID"
where
  o."Total_Amount" >= 30;

-- 8) Find the customer who spent the most on orders:
select
  *
from
  (
    select
      c."Customer_ID",
      c."Name",
      sum(o."Total_Amount") as total_spend
    from
      bookstore.customers c
      left join bookstore.orders o on c."Customer_ID" = o."Customer_ID"
    group by
      1,
      2
  ) as ct
where
  ct is not null;

-- --9) Calculate the stock remaining after fulfilling all orders:
select
  b."Book_ID",
  b."Title",
  b."Genre",
  b."Stock",
  COALESCE(sum(o."Quantity"), 0) as total_quantity,
  b."Stock" - COALESCE(sum(o."Quantity"), 0) as stock_remaining
from
  bookstore.books b
  left join bookstore.orders o on b."Book_ID" = o."Book_ID"
group by
  1,
  2,
  3,
  4;