# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

A food delivery microservices system built with Spring Boot 3.3.4, Spring Cloud 2023.0.3, Java 21, and Angular 17. The architecture uses event-driven communication via Kafka, JWT authentication, and API Gateway pattern.

## Build & Run Commands

### Building Services
```bash
# Build all services (run from each service directory)
cd user-service && mvn clean install
cd restaurant-service && mvn clean install
cd order-service && mvn clean install
cd notification-service && mvn clean install
cd api-gateway && mvn clean install
cd eureka-service && mvn clean install

# Or build a single service
cd <service-name>
mvn clean install
```

### Running Services
```bash
# Start infrastructure (Kafka & Zookeeper)
docker-compose up -d

# Run services individually (from each service directory)
mvn spring-boot:run

# Or run the JAR directly after building
java -jar target/<service-name>-0.0.1-SNAPSHOT.jar
```

### Testing
```bash
# Run tests for a specific service
cd <service-name>
mvn test

# Run specific test class
mvn test -Dtest=OrderServiceTest

# Run specific test method
mvn test -Dtest=OrderServiceTest#testCreateOrder
```

### Frontend
```bash
cd frontend
npm install
npm start  # Runs on http://localhost:4200
```

## Service Architecture

### Port Mapping
- **API Gateway**: 9000 (entry point for all client requests)
- **Eureka Service Discovery**: 8761
- **User Service**: 8081
- **Restaurant Service**: 8082
- **Order Service**: 8083
- **Notification Service**: 8084
- **Kafka**: 29092
- **Zookeeper**: 22181

### Core Services

#### API Gateway (Port 9000)
- **Gateway Pattern**: Single entry point routing requests to backend services
- **Authentication Filter**: `ConfigGlobalFilter` validates JWT tokens before routing (see api-gateway/src/main/java/com/vanhuy/api_gateway/component/ConfigGlobalFilter.java:19)
- **Public Endpoints**: Login, register, forgot/reset password, restaurants, menu-items, and Swagger docs don't require authentication
- **Circuit Breaker**: Uses Resilience4j for fault tolerance with fallback endpoints
- **Rate Limiting**: Redis-based rate limiter (10 req/sec, 50 burst capacity)
- **Routes Configuration**: api-gateway/src/main/resources/application.yaml defines all service routes

#### User Service (Port 8081)
- **Authentication**: JWT-based authentication using `JwtUtil` component
- **JWT Configuration**: Secret key and expiration (24 hours) in application.properties
- **Token Validation**: Validates tokens for API Gateway via `/api/v1/auth/validate` endpoint
- **Password Reset**: Generates time-limited reset tokens, sends email via Notification Service
- **File Upload**: Handles user profile images, stored in `src/main/resources/uploads`
- **Database**: MySQL database `user_db` with auto-create enabled

#### Restaurant Service (Port 8082)
- **Restaurant Management**: CRUD operations for restaurants and menu items
- **File Storage**: Custom `FileStorageService` handles restaurant/menu item images
- **Search Functionality**: Advanced search with `RestaurantSearchCriteria` and projections
- **Menu Items**: Nested entity under Restaurant with pricing information
- **Database**: MySQL with JPA/Hibernate

#### Order Service (Port 8083)
- **Order Processing**: Creates orders by aggregating user, restaurant, and menu item data
- **Service Communication**: Uses Feign clients (`UserServiceClient`, `RestaurantClient`, `NotificationClient`)
- **Price Calculation**: Fetches menu item prices from Restaurant Service, applies tax rate (defined in `Constants.TAX_RATE`)
- **Event Publishing**: Sends order confirmation to Kafka for async notification (see order-service/src/main/java/com/vanhuy/order_service/service/OrderService.java:129)
- **Order Status**: Tracks PENDING/CONFIRMED/DELIVERED status and payment status
- **Async Notifications**: Uses CompletableFuture for non-blocking notification sending

#### Notification Service (Port 8084)
- **Event-Driven**: Kafka consumer listening to 3 topics: `email-register-topic`, `forgot-password-topic`, `order-notification-topic`
- **Email Templates**: Thymeleaf templates for registration, password reset, and order confirmation
- **Kafka Consumer**: `NotificationKafkaConsumer` handles different message types (EmailRequest, EmailResetRequest, OrderResponse) (see notification-service/src/main/java/com/vanhuy/notification_service/kafka/NotificationKafkaConsumer.java:24)
- **Email Configuration**: SMTP settings in application.properties (currently configured for Gmail)

### Communication Patterns

1. **Synchronous Communication**:
   - Order Service → User Service (fetch user details)
   - Order Service → Restaurant Service (fetch menu item prices)
   - API Gateway → User Service (JWT validation)
   - Uses RestTemplate/Feign clients

2. **Asynchronous Communication**:
   - Order Service → Notification Service (order confirmations via Kafka)
   - User Service → Notification Service (registration emails, password resets via Kafka)
   - Kafka topics configured in notification-service/src/main/resources/application.properties

3. **API Gateway Flow**:
   - All requests enter through port 9000
   - ConfigGlobalFilter validates JWT for protected endpoints
   - Routes to appropriate service based on path
   - Circuit breaker provides fallbacks on service failures

## Key Implementation Details

### JWT Authentication Flow
1. User logs in via User Service `/api/v1/auth/login`
2. JWT token generated with 24-hour expiration using HS256 algorithm
3. API Gateway validates token by calling User Service `/api/v1/auth/validate`
4. Token must be sent as `Authorization: Bearer <token>` header

### Order Creation Flow
1. Client sends order to Order Service via API Gateway
2. Order Service fetches menu item prices from Restaurant Service
3. Calculates subtotal, applies tax rate, saves order to database
4. Asynchronously publishes order details to Kafka `order-notification-topic`
5. Notification Service consumes event and sends confirmation email

### Circuit Breaker Configuration
- Configured in api-gateway/src/main/resources/application.yaml
- Sliding window of 10 requests
- 50% failure rate threshold
- 10-second wait in open state before half-open transition
- Fallback endpoints in `FallbackController`

## Database Configuration

Each service requires MySQL database configuration in application.properties:
- User Service: `user_db`
- Restaurant Service: Configure datasource URL
- Order Service: Configure datasource URL
- All use `spring.jpa.hibernate.ddl-auto=update` for schema management

## Important Notes

- **Eureka Client**: Currently commented out in API Gateway pom.xml (services can run without service discovery)
- **Redis Required**: API Gateway rate limiter requires Redis running on localhost:6379
- **Kafka Required**: Start Kafka via docker-compose before running Order or Notification services
- **File Uploads**: User and Restaurant services store uploaded files locally in `src/main/resources/uploads`
- **CORS**: Configured in API Gateway for Angular frontend at `http://localhost:4200`
- **Swagger Documentation**: Available at `http://localhost:<service-port>/swagger-ui.html` for User, Restaurant, and Order services

## Development Workflow

1. Start infrastructure: `docker-compose up -d` (Kafka, Zookeeper)
2. Start Eureka Service (optional): `cd eureka-service && mvn spring-boot:run`
3. Start core services in order: User → Restaurant → Order → Notification
4. Start API Gateway last: `cd api-gateway && mvn spring-boot:run`
5. Start frontend: `cd frontend && npm start`

## Troubleshooting

- **Port conflicts**: Check if services are already running on configured ports
- **JWT validation fails**: Verify JWT secret key matches between User Service and API Gateway
- **Kafka connection errors**: Ensure docker-compose is running and Kafka is on port 29092
- **Rate limiting errors**: Verify Redis is running on port 6379
- **Database errors**: Check MySQL is running and credentials in application.properties are correct
