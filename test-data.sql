-- ========================================
-- FOOD ORDER MICROSERVICE - TEST DATA
-- ========================================
-- Este script contiene datos de prueba para:
-- - User Service (user_db)
-- - Restaurant Service
-- - Order Service
-- ========================================

-- ========================================
-- USER SERVICE (user_db)
-- ========================================

-- Tabla: users
-- NOTA: La contraseña 'admin' está hasheada con BCrypt (strength 10)
-- Para otros usuarios, la contraseña es 'password123' hasheada
INSERT INTO users (user_id, username, email, password, address, profile_image_name, is_active) VALUES
(1, 'admin', 'admin@foodorder.com', '$2a$10$N9qo8uLOickgx2ZMRZoMyeIjZAgcfl7p92ldGxad68LJZdL17lhWy', 'Calle Admin 123, Madrid', NULL, 1),
(2, 'juanperez', 'juan.perez@email.com', '$2a$10$dXJ3SW6G7P50lGmMkkmwe.20cQQubK3.HZWzG3YB1tlRy.fqvM/BG', 'Av. Libertador 456, Buenos Aires', NULL, 1),
(3, 'mariagarcia', 'maria.garcia@email.com', '$2a$10$dXJ3SW6G7P50lGmMkkmwe.20cQQubK3.HZWzG3YB1tlRy.fqvM/BG', 'Calle Mayor 789, Barcelona', NULL, 1),
(4, 'carloslopez', 'carlos.lopez@email.com', '$2a$10$dXJ3SW6G7P50lGmMkkmwe.20cQQubK3.HZWzG3YB1tlRy.fqvM/BG', 'Paseo de la Reforma 321, México DF', NULL, 1),
(5, 'anamartinez', 'ana.martinez@email.com', '$2a$10$dXJ3SW6G7P50lGmMkkmwe.20cQQubK3.HZWzG3YB1tlRy.fqvM/BG', 'Calle Bolívar 654, Bogotá', NULL, 1),
(6, 'pedrosanchez', 'pedro.sanchez@email.com', '$2a$10$dXJ3SW6G7P50lGmMkkmwe.20cQQubK3.HZWzG3YB1tlRy.fqvM/BG', 'Av. Paulista 987, São Paulo', NULL, 1);

-- Tabla: user_roles
INSERT INTO user_roles (user_id, role) VALUES
(1, 'ROLE_ADMIN'),
(1, 'ROLE_USER'),
(2, 'ROLE_USER'),
(3, 'ROLE_USER'),
(4, 'ROLE_USER'),
(5, 'ROLE_USER'),
(6, 'ROLE_USER');

-- ========================================
-- RESTAURANT SERVICE
-- ========================================

-- Tabla: restaurants
INSERT INTO restaurants (restaurant_id, name, address, image) VALUES
(1, 'La Parrilla Argentina', 'Calle de Alcalá 123, Madrid', 'parrilla-argentina.jpg'),
(2, 'Sushi Master', 'Paseo de Gracia 456, Barcelona', 'sushi-master.jpg'),
(3, 'Pizza Napoletana', 'Gran Vía 789, Madrid', 'pizza-napoletana.jpg'),
(4, 'Tacos El Poblano', 'Rambla Catalunya 321, Barcelona', 'tacos-poblano.jpg'),
(5, 'Burger House', 'Calle Serrano 654, Madrid', 'burger-house.jpg'),
(6, 'Healthy Bowl', 'Diagonal 987, Barcelona', 'healthy-bowl.jpg');

-- Tabla: menu_items
-- La Parrilla Argentina
INSERT INTO menu_items (item_id, name, price, stock, image_url, restaurant_id) VALUES
(1, 'Bife de Chorizo', 18.50, 50, 'bife-chorizo.jpg', 1),
(2, 'Asado de Tira', 16.00, 40, 'asado-tira.jpg', 1),
(3, 'Empanadas de Carne (x6)', 8.50, 100, 'empanadas.jpg', 1),
(4, 'Provoleta', 7.00, 60, 'provoleta.jpg', 1),
(5, 'Ensalada Mixta', 6.50, 80, 'ensalada.jpg', 1);

-- Sushi Master
INSERT INTO menu_items (item_id, name, price, stock, image_url, restaurant_id) VALUES
(6, 'Sushi Combinado (24 piezas)', 22.00, 30, 'sushi-combo.jpg', 2),
(7, 'Sashimi de Salmón', 15.50, 25, 'sashimi-salmon.jpg', 2),
(8, 'Ramen Tonkotsu', 12.00, 40, 'ramen.jpg', 2),
(9, 'California Roll', 9.50, 50, 'california-roll.jpg', 2),
(10, 'Gyozas (8 piezas)', 7.50, 60, 'gyozas.jpg', 2);

-- Pizza Napoletana
INSERT INTO menu_items (item_id, name, price, stock, image_url, restaurant_id) VALUES
(11, 'Pizza Margherita', 10.00, 70, 'margherita.jpg', 3),
(12, 'Pizza Quattro Formaggi', 12.50, 60, 'quattro-formaggi.jpg', 3),
(13, 'Pizza Diavola', 11.50, 65, 'diavola.jpg', 3),
(14, 'Calzone Napolitano', 11.00, 45, 'calzone.jpg', 3),
(15, 'Bruschetta (6 unidades)', 6.00, 80, 'bruschetta.jpg', 3);

-- Tacos El Poblano
INSERT INTO menu_items (item_id, name, price, stock, image_url, restaurant_id) VALUES
(16, 'Tacos al Pastor (3 unidades)', 9.00, 90, 'tacos-pastor.jpg', 4),
(17, 'Tacos de Carnitas (3 unidades)', 9.50, 85, 'tacos-carnitas.jpg', 4),
(18, 'Quesadilla de Pollo', 8.00, 70, 'quesadilla.jpg', 4),
(19, 'Nachos con Guacamole', 7.50, 100, 'nachos.jpg', 4),
(20, 'Burrito Mexicano', 10.50, 60, 'burrito.jpg', 4);

-- Burger House
INSERT INTO menu_items (item_id, name, price, stock, image_url, restaurant_id) VALUES
(21, 'Classic Burger', 9.50, 80, 'classic-burger.jpg', 5),
(22, 'Bacon Cheeseburger', 11.00, 75, 'bacon-burger.jpg', 5),
(23, 'Veggie Burger', 10.00, 50, 'veggie-burger.jpg', 5),
(24, 'Chicken Burger', 9.00, 70, 'chicken-burger.jpg', 5),
(25, 'Papas Fritas', 4.50, 150, 'fries.jpg', 5);

-- Healthy Bowl
INSERT INTO menu_items (item_id, name, price, stock, image_url, restaurant_id) VALUES
(26, 'Poke Bowl de Salmón', 13.50, 40, 'poke-salmon.jpg', 6),
(27, 'Buddha Bowl Vegano', 11.00, 50, 'buddha-bowl.jpg', 6),
(28, 'Ensalada Caesar con Pollo', 10.50, 60, 'caesar-salad.jpg', 6),
(29, 'Smoothie Bowl', 8.50, 45, 'smoothie-bowl.jpg', 6),
(30, 'Wrap de Pollo y Aguacate', 9.00, 55, 'chicken-wrap.jpg', 6);

-- ========================================
-- ORDER SERVICE
-- ========================================

-- Tabla: orders
INSERT INTO orders (order_id, user_id, order_date, total_amount, status, payment_status, is_deleted, recipient_name, contact_email, shipping_address, contact_phone) VALUES
(1, 2, '2025-01-15 12:30:00', 35.70, 'DELIVERED', 'PAID', 0, 'Juan Pérez', 'juan.perez@email.com', 'Av. Libertador 456, Buenos Aires', '+54 11 1234-5678'),
(2, 3, '2025-01-16 14:45:00', 44.00, 'DELIVERED', 'PAID', 0, 'María García', 'maria.garcia@email.com', 'Calle Mayor 789, Barcelona', '+34 933 123 456'),
(3, 4, '2025-01-17 19:20:00', 27.00, 'READY', 'PAID', 0, 'Carlos López', 'carlos.lopez@email.com', 'Paseo de la Reforma 321, México DF', '+52 55 1234 5678'),
(4, 5, '2025-01-18 13:15:00', 39.50, 'PREPARING', 'PAID', 0, 'Ana Martínez', 'ana.martinez@email.com', 'Calle Bolívar 654, Bogotá', '+57 1 234 5678'),
(5, 6, '2025-01-19 20:00:00', 31.25, 'PENDING', 'PENDING', 0, 'Pedro Sánchez', 'pedro.sanchez@email.com', 'Av. Paulista 987, São Paulo', '+55 11 91234-5678'),
(6, 2, '2025-01-20 12:00:00', 52.50, 'DELIVERED', 'PAID', 0, 'Juan Pérez', 'juan.perez@email.com', 'Av. Libertador 456, Buenos Aires', '+54 11 1234-5678');

-- Tabla: order_items
-- Orden 1 (Juan - La Parrilla Argentina)
INSERT INTO order_items (order_item_id, order_id, menu_item_id, quantity, subtotal) VALUES
(1, 1, 1, 1, 18.50),  -- Bife de Chorizo
(2, 1, 3, 1, 8.50),   -- Empanadas
(3, 1, 5, 1, 6.50);   -- Ensalada
-- Total: 33.50 + tax (6.56%) = 35.70

-- Orden 2 (María - Sushi Master)
INSERT INTO order_items (order_item_id, order_id, menu_item_id, quantity, subtotal) VALUES
(4, 2, 6, 1, 22.00),  -- Sushi Combinado
(5, 2, 8, 1, 12.00),  -- Ramen
(6, 2, 10, 1, 7.50);  -- Gyozas
-- Total: 41.50 + tax = 44.00

-- Orden 3 (Carlos - Pizza Napoletana)
INSERT INTO order_items (order_item_id, order_id, menu_item_id, quantity, subtotal) VALUES
(7, 3, 11, 2, 20.00), -- 2x Pizza Margherita
(8, 3, 15, 1, 6.00);  -- Bruschetta
-- Total: 26.00 + tax = 27.00

-- Orden 4 (Ana - Tacos El Poblano)
INSERT INTO order_items (order_item_id, order_id, menu_item_id, quantity, subtotal) VALUES
(9, 4, 16, 2, 18.00), -- 2x Tacos al Pastor
(10, 4, 18, 1, 8.00), -- Quesadilla
(11, 4, 19, 1, 7.50); -- Nachos
-- Total: 33.50 + tax = 39.50

-- Orden 5 (Pedro - Burger House)
INSERT INTO order_items (order_item_id, order_id, menu_item_id, quantity, subtotal) VALUES
(12, 5, 22, 1, 11.00), -- Bacon Cheeseburger
(13, 5, 24, 1, 9.00),  -- Chicken Burger
(14, 5, 25, 2, 9.00);  -- 2x Papas Fritas
-- Total: 29.00 + tax = 31.25

-- Orden 6 (Juan - Healthy Bowl)
INSERT INTO order_items (order_item_id, order_id, menu_item_id, quantity, subtotal) VALUES
(15, 6, 26, 2, 27.00), -- 2x Poke Bowl
(16, 6, 28, 1, 10.50), -- Ensalada Caesar
(17, 6, 29, 1, 8.50);  -- Smoothie Bowl
-- Total: 46.00 + tax = 52.50

-- ========================================
-- NOTAS DE USO
-- ========================================
-- Usuario Admin:
--   Username: admin
--   Password: admin
--   Email: admin@foodorder.com
--
-- Usuarios de prueba:
--   Todos tienen password: password123
--
-- Los IDs están configurados para facilitar las referencias:
-- - Users: 1-6
-- - Restaurants: 1-6
-- - Menu Items: 1-30 (5 items por restaurante)
-- - Orders: 1-6
-- - Order Items: 1-17
--
-- Para ejecutar este script:
-- 1. Asegúrate de que las bases de datos estén creadas
-- 2. Ejecuta este script en el orden correcto (users -> restaurants -> orders)
-- 3. O ejecuta cada sección en su base de datos correspondiente
-- ========================================
