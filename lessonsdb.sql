-- --------------------------------------------------------
-- Host:                         127.0.0.1
-- Server version:               8.0.30 - MySQL Community Server - GPL
-- Server OS:                    Win64
-- HeidiSQL Version:             12.1.0.6537
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- Dumping database structure for lessonsdb
CREATE DATABASE IF NOT EXISTS `lessonsdb` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `lessonsdb`;

-- Dumping structure for table lessonsdb.lectures
CREATE TABLE IF NOT EXISTS `lectures` (
  `id` int NOT NULL AUTO_INCREMENT,
  `created_at` datetime NOT NULL,
  `user_id` int DEFAULT NULL,
  `lecture_name` varchar(255) NOT NULL,
  `subject` varchar(100) NOT NULL,
  `chapter` varchar(255) DEFAULT NULL,
  `lecture_link` text,
  `link_genspack` text,
  `status` enum('New','Creating','Created') NOT NULL DEFAULT 'New',
  `description` varchar(5000) CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `user_id` (`user_id`),
  CONSTRAINT `lectures_ibfk_1` FOREIGN KEY (`user_id`) REFERENCES `users` (`id`)
) ENGINE=InnoDB AUTO_INCREMENT=6 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Dumping data for table lessonsdb.lectures: ~3 rows (approximately)
-- INSERT INTO `lectures` (`id`, `created_at`, `user_id`, `lecture_name`, `subject`, `chapter`, `lecture_link`, `link_genspack`, `status`, `description`) VALUES
-- 	(1, '2025-06-06 08:30:00', 1, 'Cộng các số trong phạm vi 10', 'Toán', 'Chương 1: Số học cơ bản', NULL, NULL, 'New', NULL),
-- 	(2, '2025-06-06 09:00:00', 2, 'Luyện đọc âm đầu L/N', 'Tiếng Việt', 'Chương 1: Âm đầu', NULL, NULL, 'New', NULL),
-- 	(4, '2025-06-06 10:25:18', 1, 'bài 1', 'Math', 'Chapter 1', NULL, 'http://127.0.0.1:5500/manage_slide/admin.html#', 'New', NULL);

-- Dumping structure for table lessonsdb.slides
CREATE TABLE IF NOT EXISTS `slides` (
  `id` int NOT NULL AUTO_INCREMENT,
  `lecture_id` int NOT NULL,
  `title` varchar(255) NOT NULL,
  `html_content` text,
  `slide_order` int DEFAULT NULL,
  `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  KEY `lecture_id` (`lecture_id`),
  CONSTRAINT `slides_ibfk_1` FOREIGN KEY (`lecture_id`) REFERENCES `lectures` (`id`) ON DELETE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Dumping data for table lessonsdb.slides: ~6 rows (approximately)
-- INSERT INTO `slides` (`id`, `lecture_id`, `title`, `html_content`, `slide_order`, `created_at`) VALUES
-- 	(1, 1, 'Giới thiệu bài học', '<h1>Bài học hôm nay: Cộng các số trong phạm vi 10</h1>', 1, '2025-06-06 09:39:20'),
-- 	(2, 1, 'Ví dụ minh họa', '<p>2 + 3 = 5</p>', 2, '2025-06-06 09:39:20'),
-- 	(3, 1, 'Bài tập nhỏ', '<p>Tính: 4 + 5 = ?</p>', 3, '2025-06-06 09:39:20'),
-- 	(4, 2, 'Khởi động', '<h2>Phân biệt âm L và N</h2>', 1, '2025-06-06 09:39:20'),
-- 	(5, 2, 'Ví dụ', '<ul><li>Lá</li><li>Ná</li></ul>', 2, '2025-06-06 09:39:20'),
-- 	(6, 2, 'Bài tập luyện đọc', '<p>Điền L hoặc N vào chỗ trống: __a, __a</p>', 3, '2025-06-06 09:39:20');

-- Dumping structure for table lessonsdb.users
-- CREATE TABLE IF NOT EXISTS `users` (
--   `id` int NOT NULL AUTO_INCREMENT,
--   `full_name` varchar(255) NOT NULL,
--   `email` varchar(255) DEFAULT NULL,
--   `created_at` datetime DEFAULT CURRENT_TIMESTAMP,
--   PRIMARY KEY (`id`)
-- ) ENGINE=InnoDB AUTO_INCREMENT=7 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

-- Dumping data for table lessonsdb.users: ~2 rows (approximately)
-- INSERT INTO `users` (`id`, `full_name`, `email`, `created_at`) VALUES
-- 	(1, 'Alice Nguyen', 'alice@example.com', '2025-06-06 09:09:12'),
-- 	(2, 'Bob Tran', 'bob@example.com', '2025-06-06 09:09:12');

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;