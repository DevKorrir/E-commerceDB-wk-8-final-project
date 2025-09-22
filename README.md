
# E-commerce Database Management System

A comprehensive MySQL database schema designed for a complete e-commerce platform. This database supports all core functionality needed for an online store including customer management, product catalog, order processing, payments, and inventory tracking.

## 📋 Table of Contents
- [Overview](#overview)
- [Database Schema](#database-schema)
- [Key Features](#key-features)
- [Table Relationships](#table-relationships)
- [Installation](#installation)
- [Usage Examples](#usage-examples)
- [Database Structure](#database-structure)
- [Performance Considerations](#performance-considerations)
- [Contributing](#contributing)

## 🔍 Overview

This database schema implements a full-featured e-commerce system with:
- **17 main tables** with proper relationships
- **Complete referential integrity** with foreign key constraints
- **Performance optimized** with strategic indexes
- **Scalable design** supporting business growth
- **Data validation** through check constraints

## 🗄️ Database Schema

### Core Entities
- **Customers**: User accounts and authentication
- **Products**: Product catalog with detailed specifications
- **Orders**: Complete order management system
- **Payments**: Payment processing and tracking
- **Inventory**: Stock management and tracking

### Supporting Entities
- **Categories**: Hierarchical product categorization
- **Suppliers**: Vendor management
- **Reviews**: Customer feedback system
- **Coupons**: Discount and promotion system
- **Shipments**: Delivery tracking

## ✨ Key Features

### 🛒 **E-commerce Functionality**
- Complete product catalog with categories and suppliers
- Shopping cart management
- Wishlist functionality
- Order processing workflow
- Payment integration support
- Shipment tracking

### 👥 **Customer Management**
- User registration and authentication
- Multiple address support per customer
- Order history tracking
- Review and rating system

### 📦 **Inventory Management**
- Real-time stock tracking
- Automatic reorder alerts
- Inventory transaction history
- Supplier management

### 💰 **Financial Features**
- Multiple payment methods
- Coupon and discount system
- Tax calculation support
- Currency support

### 📊 **Analytics Ready**
- Pre-built views for common queries
- Comprehensive indexing for performance
- Transaction history for reporting

## 🔗 Table Relationships

### One-to-Many Relationships
- `customers` → `customer_addresses`
- `customers` → `orders`
- `products` → `product_images`
- `categories` → `products`
- `suppliers` → `products`
- `orders` → `order_items`

### One-to-One Relationships
- `orders` ↔ `payments`
- `orders` ↔ `shipments`
- `products` ↔ `inventory`

### Many-to-Many Relationships
- `products` ↔ `categories` (via `product_categories`)
- `customers` ↔ `products` (via `shopping_cart`)
- `customers` ↔ `products` (via `wishlists`)
- `customers` ↔ `products` (via `product_reviews`)
- `orders` ↔ `coupons` (via `order_coupons`)

## 🚀 Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/DevKorrir/E-commerceDB-wk-8-final-project.git
   cd ecommerce-database
   ```

2. **Import the database**
   ```bash
   mysql -u your_username -p < ecommerce_database.sql
   ```

3. **Verify installation**
   ```sql
   USE ecommerceDB;
   SHOW TABLES;
   ```

## 💡 Usage Examples

### Create a Customer
```sql
INSERT INTO customers (first_name, last_name, email, password_hash)
VALUES ('John', 'Doe', 'john.doe@example.com', 'hashed_password_here');
```

### Add Customer Address
```sql
INSERT INTO customers_addresses (customer_id, label, street, city, country)
VALUES (1, 'Home', '123 Main St', 'New York', 'USA');
```

### Create a Product
```sql
INSERT INTO products (product_name, sku, price, category_id, stock_quantity)
VALUES ('Laptop Computer', 'LAP-001', 999.99, 1, 50);
```

### Place an Order
```sql
-- Create order
INSERT INTO orders (customer_id, total_amount)
VALUES (1, 1299.98);

-- Add order items
INSERT INTO order_items (order_id, product_id, quantity, unit_price, total_price)
VALUES (1, 1, 1, 999.99, 999.99);
```

### View Order Summary
```sql
SELECT * FROM vw_order_summary WHERE customer_id = 1;
```

## 🏗️ Database Structure

### Tables Overview
| Table | Purpose | Key Relationships |
|-------|---------|-------------------|
| `customers` | Customer accounts | → addresses, orders, reviews |
| `products` | Product catalog | → categories, suppliers, inventory |
| `orders` | Order management | → customers, payments, shipments |
| `order_items` | Order line items | → orders, products |
| `payments` | Payment tracking | → orders |
| `inventory` | Stock management | → products |
| `categories` | Product categorization | Self-referencing hierarchy |
| `suppliers` | Vendor management | → products |
| `shopping_cart` | Cart functionality | → customers, products |
| `wishlists` | Wishlist feature | → customers, products |
| `product_reviews` | Review system | → customers, products |
| `coupons` | Discount system | → order_coupons |
| `shipments` | Delivery tracking | → orders |

### Key Constraints
- **Primary Keys**: Auto-incrementing IDs on all tables
- **Foreign Keys**: Referential integrity with CASCADE/RESTRICT rules
- **Unique Constraints**: Email, SKU, tracking numbers
- **Check Constraints**: Price validation, rating ranges, quantity limits
- **Not Null**: Required fields enforced

## ⚡ Performance Considerations

### Indexes Created
- Customer email lookups
- Product SKU and price searches
- Order status and date filtering
- Review ratings and product associations
- Inventory quantity tracking

### Views Available
- `vw_order_summary`: Complete order information with customer details
- `vw_product_inventory`: Product stock status and availability

### Optimization Tips
1. Use prepared statements for frequent queries
2. Implement connection pooling
3. Consider read replicas for reporting
4. Monitor slow query log
5. Regular ANALYZE TABLE maintenance

## 🛠️ Database Maintenance

### Regular Tasks
- **Backup**: Daily automated backups recommended
- **Index Optimization**: Monthly ANALYZE TABLE on large tables
- **Cleanup**: Archive old orders and transaction data
- **Monitoring**: Track database size and performance metrics

### Scaling Considerations
- Partition large tables (orders, order_items) by date
- Consider separate read replicas for reporting
- Implement caching layer for frequently accessed data
- Monitor and optimize slow queries

## 📝 Schema Modifications

When modifying the schema:
1. Always backup before changes
2. Test in development environment first
3. Consider impact on existing data
4. Update indexes after structural changes
5. Document all modifications

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test thoroughly
5. Submit a pull request

## 📄 License

This project is open source and available under the [MIT License](LICENSE).

## 🔧 Technical Requirements

- **MySQL**: Version 5.7+ or 8.0+
- **Character Set**: utf8mb4 for full Unicode support
- **Storage Engine**: InnoDB (MySQL default)
- **Minimum RAM**: 4GB recommended for development
- **Disk Space**: Plan for data growth (start with 10GB minimum)

## 📞 Support

For questions or issues:
1. Check existing documentation
2. Review common usage patterns
3. Submit issues with detailed description
4. Include database version and error messages

---

**Built with ❤️ for modern e-commerce applications**

*Last updated: September 2025*
