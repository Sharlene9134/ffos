-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Dec 18, 2025 at 09:31 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `ffos`
--

-- --------------------------------------------------------

--
-- Table structure for table `bundles`
--

CREATE TABLE `bundles` (
  `id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `price` decimal(10,2) NOT NULL DEFAULT 0.00,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `bundle_items`
--

CREATE TABLE `bundle_items` (
  `id` int(11) NOT NULL,
  `bundle_id` int(11) NOT NULL,
  `menu_item_id` int(11) NOT NULL,
  `quantity` int(11) NOT NULL DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `bundle_items`
--

INSERT INTO `bundle_items` (`id`, `bundle_id`, `menu_item_id`, `quantity`, `created_at`, `updated_at`) VALUES
(8, 51, 1, 1, '2025-12-18 06:36:22', '2025-12-18 06:36:22'),
(12, 48, 1, 2, '2025-12-18 07:40:44', '2025-12-18 07:40:44'),
(13, 48, 4, 4, '2025-12-18 07:40:44', '2025-12-18 07:40:44'),
(14, 48, 3, 4, '2025-12-18 07:40:44', '2025-12-18 07:40:44'),
(15, 48, 30, 4, '2025-12-18 07:40:44', '2025-12-18 07:40:44'),
(16, 48, 41, 1, '2025-12-18 07:40:44', '2025-12-18 07:40:44'),
(17, 50, 1, 1, '2025-12-18 07:41:41', '2025-12-18 07:41:41'),
(18, 50, 4, 1, '2025-12-18 07:41:41', '2025-12-18 07:41:41'),
(19, 50, 3, 1, '2025-12-18 07:41:41', '2025-12-18 07:41:41'),
(20, 52, 3, 1, '2025-12-18 07:42:48', '2025-12-18 07:42:48'),
(21, 52, 39, 1, '2025-12-18 07:42:48', '2025-12-18 07:42:48'),
(22, 52, 32, 1, '2025-12-18 07:42:48', '2025-12-18 07:42:48'),
(23, 7, 2, 1, '2025-12-18 07:44:10', '2025-12-18 07:44:10'),
(24, 7, 40, 1, '2025-12-18 07:44:10', '2025-12-18 07:44:10'),
(25, 7, 38, 1, '2025-12-18 07:44:10', '2025-12-18 07:44:10'),
(26, 7, 35, 1, '2025-12-18 07:44:10', '2025-12-18 07:44:10'),
(27, 43, 30, 3, '2025-12-18 07:45:11', '2025-12-18 07:45:11'),
(28, 43, 36, 3, '2025-12-18 07:45:11', '2025-12-18 07:45:11'),
(29, 43, 32, 3, '2025-12-18 07:45:11', '2025-12-18 07:45:11');

-- --------------------------------------------------------

--
-- Table structure for table `menu_items`
--

CREATE TABLE `menu_items` (
  `id` int(11) NOT NULL,
  `code` varchar(20) NOT NULL,
  `category_id` int(11) DEFAULT NULL,
  `is_bundle` tinyint(1) NOT NULL DEFAULT 0,
  `name` varchar(100) NOT NULL,
  `price` decimal(10,2) NOT NULL,
  `image_path` varchar(255) DEFAULT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `menu_items`
--

INSERT INTO `menu_items` (`id`, `code`, `category_id`, `is_bundle`, `name`, `price`, `image_path`, `is_active`) VALUES
(1, 'BIGMAC', NULL, 0, 'Big Mac Meal', 150.00, NULL, 0),
(2, 'MCCHKN', NULL, 0, 'McChicken Meal', 140.00, NULL, 0),
(3, 'FRIESL', NULL, 0, 'Large Fries', 60.00, NULL, 0),
(4, 'COKEL', NULL, 0, 'Large Coke', 45.00, NULL, 0),
(5, 'wfwqfwq', 1, 0, 'safasf', 51581.00, 'uploads/prod_692cfa68962f31.90440074.jpg', 0),
(6, 'dsada', NULL, 1, 'jkanbjksak', 815.00, NULL, 0),
(7, 'ComMeal', NULL, 1, 'Combo Meal', 269.00, '', 0),
(8, 'ww', 1, 0, 'sda', 242.00, NULL, 0),
(9, 'llp', NULL, 1, 'wet', 105.00, NULL, 0),
(10, 'tew', NULL, 1, 'tew', 340.00, NULL, 0),
(11, 'hhh', NULL, 1, 'n', 45.00, '', 0),
(12, 'wwrt', 2, 0, 'efawefg', 325325.00, NULL, 0),
(27, 'BRG001', 1, 0, 'Classic Cheeseburger', 79.00, 'images/burger1.jpg', 1),
(28, 'BRG002', 1, 0, 'Beef BBQ Burger', 99.00, 'images/burger2.jpg', 1),
(29, 'BRG003', 1, 0, 'Double Patty Stack', 129.00, 'images/burger3.jpg', 1),
(30, 'CHK001', 2, 0, '1-PC Crispy Chicken', 89.00, 'images/chicken1.jpg', 1),
(31, 'CHK002', 2, 0, '2-PC Chicken with Rice', 149.00, 'images/chicken2.jpg', 1),
(32, 'SDE001', 3, 0, 'Regular Fries', 39.00, 'images/fries1.jpg', 1),
(33, 'SDE002', 3, 0, 'Large Fries', 59.00, 'images/fries2.jpg', 1),
(34, 'SDE003', 3, 0, 'Butter Corn Cup', 35.00, 'images/corn1.jpg', 1),
(35, 'DRK001', 4, 0, 'Iced Tea', 35.00, 'images/icedtea.jpg', 1),
(36, 'DRK002', 4, 0, 'Soft Drink (Soda)', 30.00, 'images/soda.jpg', 1),
(37, 'DRK003', 4, 0, 'Bottled Water', 25.00, 'images/water.jpg', 1),
(38, 'DST001', 5, 0, 'Vanilla Sundae', 45.00, 'images/sundae1.jpg', 1),
(39, 'DST002', 5, 0, 'Choco Sundae', 55.00, 'images/sundae2.jpg', 1),
(40, 'DST003', 5, 0, 'Apple Pie', 49.00, 'images/pie1.jpg', 1),
(41, 'CHKNGTS', 2, 0, 'Chicken Nuggets', 100.00, NULL, 1),
(42, 'DRK004', 4, 0, 'Large Sprite', 25.00, NULL, 1),
(43, 'FM2', NULL, 1, 'Family Meal', 474.00, '', 1),
(45, 'fknfkd c', NULL, 1, 'sfcszxc', 45.00, NULL, 1),
(47, 'xzhcghasd', NULL, 1, 'sdasd', 195.00, NULL, 1),
(48, 'FM1', NULL, 1, 'Family Meal', 1176.00, '', 1),
(50, 'SM1', NULL, 1, 'Solo Meal', 255.00, '', 1),
(51, 'rhcvnv', NULL, 1, 'rgcx', 150.00, NULL, 1),
(52, 'snack meal', NULL, 1, 'Snack Meal', 154.00, '', 1);

-- --------------------------------------------------------

--
-- Table structure for table `orders`
--

CREATE TABLE `orders` (
  `id` int(11) NOT NULL,
  `terminal_id` int(11) DEFAULT NULL,
  `teller_terminal_id` int(11) DEFAULT NULL,
  `total_amount` decimal(10,2) NOT NULL DEFAULT 0.00,
  `cash_received` decimal(10,2) DEFAULT 0.00,
  `change_amount` decimal(10,2) DEFAULT 0.00,
  `status` enum('UNPAID','PAID','IN_PROCESS','READY_FOR_CLAIM','COMPLETED','CANCELLED','CLAIMED') NOT NULL DEFAULT 'UNPAID',
  `paid_at` timestamp NULL DEFAULT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp(),
  `updated_at` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  `display_number` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `orders`
--

INSERT INTO `orders` (`id`, `terminal_id`, `teller_terminal_id`, `total_amount`, `cash_received`, `change_amount`, `status`, `paid_at`, `created_at`, `updated_at`, `display_number`) VALUES
(1, NULL, NULL, 51881.00, 0.00, 0.00, 'CANCELLED', '2025-11-30 22:11:18', '2025-12-01 04:19:51', '2025-12-01 05:40:12', NULL),
(2, NULL, NULL, 150.00, 0.00, 0.00, 'CANCELLED', '2025-11-30 22:35:29', '2025-11-30 22:08:28', '2025-12-01 05:40:14', 1),
(3, NULL, NULL, 150.00, 0.00, 0.00, 'CANCELLED', '2025-11-30 22:35:54', '2025-11-30 22:28:19', '2025-12-01 05:40:17', 2),
(4, NULL, NULL, 195.00, 0.00, 0.00, 'CANCELLED', '2025-11-30 22:40:47', '2025-11-30 22:40:39', '2025-12-01 05:45:51', 3),
(5, 1, 2, 210.00, 0.00, 0.00, 'CANCELLED', '2025-11-30 23:00:38', '2025-11-30 22:46:16', '2025-12-01 06:16:05', 4),
(6, 1, 2, 965.00, 1000.00, 35.00, '', '2025-11-30 23:16:28', '2025-11-30 23:16:23', '2025-11-30 23:38:58', 5),
(7, 1, 2, 105.00, 200.00, 95.00, '', '2025-11-30 23:46:24', '2025-11-30 23:44:58', '2025-11-30 23:47:00', 6),
(8, 1, 2, 60.00, 100.00, 40.00, 'CLAIMED', '2025-12-01 00:24:48', '2025-12-01 00:24:28', '2025-12-01 00:30:31', 7),
(9, 1, 2, 242.00, 500.00, 258.00, 'CLAIMED', '2025-12-01 01:49:13', '2025-12-01 00:38:28', '2025-12-01 01:50:36', 8),
(10, 1, 2, 965.00, 1000.00, 35.00, 'CLAIMED', '2025-12-01 01:53:33', '2025-12-01 00:40:44', '2025-12-01 01:53:53', 9),
(11, 1, 2, 340.00, 500.00, 160.00, 'CLAIMED', '2025-12-01 01:49:20', '2025-12-01 00:41:01', '2025-12-01 01:50:38', 10),
(12, 1, 2, 326.00, 400.00, 74.00, 'CLAIMED', '2025-12-01 01:53:45', '2025-12-01 01:33:39', '2025-12-01 01:54:00', 11),
(13, 1, 2, 56486.00, 100000.00, 43514.00, 'CLAIMED', '2025-12-01 01:47:04', '2025-12-01 01:37:48', '2025-12-01 01:47:55', 12),
(14, 1, 2, 525.00, 600.00, 75.00, 'CLAIMED', '2025-12-01 01:41:33', '2025-12-01 01:38:03', '2025-12-01 01:48:01', 13),
(15, 1, 2, 306.00, 500.00, 194.00, 'CLAIMED', '2025-12-01 01:44:56', '2025-12-01 01:41:15', '2025-12-01 01:47:15', 14),
(16, 1, 2, 495.00, 4000.00, 3505.00, 'CLAIMED', '2025-12-01 01:53:49', '2025-12-01 01:45:16', '2025-12-01 01:54:09', 15),
(17, 1, 2, 294.00, 700.00, 406.00, 'CLAIMED', '2025-12-01 01:47:46', '2025-12-01 01:45:27', '2025-12-01 01:48:19', 16),
(18, 1, 2, 1461.00, 2000.00, 539.00, 'CLAIMED', '2025-12-01 01:51:00', '2025-12-01 01:46:00', '2025-12-01 01:51:19', 17),
(19, 1, 2, 11771.00, 99999999.99, 99999999.99, 'CLAIMED', '2025-12-01 01:49:28', '2025-12-01 01:46:18', '2025-12-01 01:50:39', 18),
(20, 1, 2, 243.00, 6969.00, 6726.00, 'CLAIMED', '2025-12-01 01:49:37', '2025-12-01 01:46:24', '2025-12-01 01:50:45', 19),
(21, 1, 2, 149.00, 40000.00, 39851.00, 'CLAIMED', '2025-12-01 01:53:55', '2025-12-01 01:46:51', '2025-12-01 01:54:11', 20),
(22, 1, 2, 6854.00, 69420.00, 62566.00, 'CLAIMED', '2025-12-01 01:49:49', '2025-12-01 01:46:55', '2025-12-01 01:50:41', 21),
(23, 1, 2, 1683.00, 99999999.99, 99999999.99, 'CLAIMED', '2025-12-01 01:55:41', '2025-12-01 01:47:21', '2025-12-01 01:56:09', 22),
(24, 1, 2, 223.00, 300.00, 77.00, 'CLAIMED', '2025-12-01 01:47:52', '2025-12-01 01:47:24', '2025-12-01 01:48:31', 23),
(25, 1, 2, 99.00, 99999999.99, 99999999.99, 'CLAIMED', '2025-12-01 01:55:45', '2025-12-01 01:47:44', '2025-12-01 01:56:12', 24),
(26, 1, 2, 99999999.99, 99999999.99, 99999999.99, 'CLAIMED', '2025-12-01 01:50:10', '2025-12-01 01:48:22', '2025-12-01 01:50:48', 25),
(27, 1, 2, 99999999.99, 99999999.99, 99999999.99, 'CLAIMED', '2025-12-01 01:50:06', '2025-12-01 01:48:32', '2025-12-01 01:50:50', 26),
(28, 1, 2, 802.00, 1000.00, 198.00, 'CLAIMED', '2025-12-01 01:50:55', '2025-12-01 01:48:36', '2025-12-01 01:51:15', 27),
(29, 1, 2, 293.00, 99999999.99, 99999999.99, 'CLAIMED', '2025-12-01 01:55:54', '2025-12-01 01:48:50', '2025-12-01 01:56:24', 28),
(30, 1, 2, 422.00, 800.00, 378.00, 'CLAIMED', '2025-12-01 01:50:24', '2025-12-01 01:48:54', '2025-12-01 01:50:52', 29),
(31, 1, 2, 511.00, 99999999.99, 99999999.99, 'CLAIMED', '2025-12-01 01:55:58', '2025-12-01 01:49:23', '2025-12-01 01:56:27', 30),
(32, 1, 2, 402.00, 500.00, 98.00, 'CLAIMED', '2025-12-01 01:51:13', '2025-12-01 01:49:36', '2025-12-01 01:51:21', 31),
(33, 1, 2, 1667166.00, 99999999.99, 99999999.99, 'CLAIMED', '2025-12-01 01:51:26', '2025-12-01 01:50:42', '2025-12-01 01:51:43', 32),
(34, 1, 2, 455.00, 500.00, 45.00, 'CLAIMED', '2025-12-01 01:51:35', '2025-12-01 01:51:02', '2025-12-01 01:51:45', 33),
(35, 1, 2, 1032.00, 99999999.99, 99998968.00, 'CLAIMED', '2025-12-01 01:51:45', '2025-12-01 01:51:16', '2025-12-01 01:51:54', 34),
(36, 1, 2, 99999999.99, 99999999.99, 99999999.99, 'CLAIMED', '2025-12-01 01:54:54', '2025-12-01 01:53:11', '2025-12-01 01:55:34', 35),
(37, 1, 2, 790.00, 10000.00, 9210.00, 'CLAIMED', '2025-12-01 01:55:13', '2025-12-01 01:53:33', '2025-12-01 01:55:39', 36),
(38, 1, 2, 237.00, 200000.00, 199763.00, 'CLAIMED', '2025-12-01 01:54:34', '2025-12-01 01:53:41', '2025-12-01 01:55:06', 37),
(39, 1, 2, 2082.00, 99999999.99, 99999999.99, 'CLAIMED', '2025-12-01 01:55:04', '2025-12-01 01:53:51', '2025-12-01 01:55:36', 38),
(40, 1, 2, 18509.00, 20000.00, 1491.00, 'CLAIMED', '2025-12-01 01:54:17', '2025-12-01 01:53:53', '2025-12-01 01:55:32', 39),
(41, 1, 2, 3068.00, 100000.00, 96932.00, 'CLAIMED', '2025-12-01 01:55:19', '2025-12-01 01:53:59', '2025-12-01 01:55:41', 40),
(42, 1, 2, 3974.00, 10000.00, 6026.00, 'CLAIMED', '2025-12-01 01:55:30', '2025-12-01 01:54:14', '2025-12-01 01:55:45', 41),
(43, 1, 2, 4360.00, 1000000.00, 995640.00, 'CLAIMED', '2025-12-01 01:55:25', '2025-12-01 01:54:51', '2025-12-01 01:55:43', 42),
(44, 1, 2, 1691.00, 99999999.99, 99999999.99, 'CLAIMED', '2025-12-01 01:55:35', '2025-12-01 01:55:21', '2025-12-01 01:55:48', 43),
(45, 1, 2, 3225.00, 99999999.99, 99999999.99, 'CLAIMED', '2025-12-01 01:56:04', '2025-12-01 01:55:33', '2025-12-01 01:56:30', 44),
(46, 1, 2, 1027.00, 21100.00, 20073.00, 'CLAIMED', '2025-12-01 01:56:19', '2025-12-01 01:55:39', '2025-12-01 01:56:33', 45),
(47, 1, 2, 315.00, 99999999.99, 99999999.99, 'CLAIMED', '2025-12-01 01:56:24', '2025-12-01 01:55:41', '2025-12-01 01:56:35', 46),
(48, 1, 2, 110.00, 99999999.99, 99999999.99, 'CLAIMED', '2025-12-01 01:56:31', '2025-12-01 01:55:42', '2025-12-01 01:56:38', 47),
(49, 1, 2, 98.00, 99999999.99, 99999999.99, 'CLAIMED', '2025-12-01 01:56:36', '2025-12-01 01:55:44', '2025-12-01 01:58:01', 48),
(50, 1, 2, 298.00, 99999999.99, 99999999.99, 'CLAIMED', '2025-12-01 01:56:41', '2025-12-01 01:55:46', '2025-12-01 01:57:59', 49),
(51, 1, 2, 445.00, 99999999.99, 99999999.99, 'CLAIMED', '2025-12-01 01:56:45', '2025-12-01 01:55:48', '2025-12-01 01:57:39', 50),
(52, 1, 2, 387.00, 10000000.00, 9999613.00, 'CLAIMED', '2025-12-01 01:56:50', '2025-12-01 01:55:50', '2025-12-01 01:58:03', 51),
(53, 1, 2, 237.00, 0.00, 0.00, 'CANCELLED', NULL, '2025-12-01 01:55:52', '2025-12-01 01:56:54', 52),
(54, 1, 2, 98.00, 0.00, 0.00, 'CANCELLED', NULL, '2025-12-01 01:55:54', '2025-12-01 01:56:55', 53),
(55, 1, 2, 110.00, 0.00, 0.00, 'CANCELLED', NULL, '2025-12-01 01:55:56', '2025-12-01 01:56:57', 54),
(56, 1, 2, 425.00, 0.00, 0.00, 'CANCELLED', NULL, '2025-12-01 01:56:04', '2025-12-01 01:56:59', 55),
(57, 1, 2, 294.00, 0.00, 0.00, 'CANCELLED', NULL, '2025-12-01 01:56:07', '2025-12-01 01:57:00', 56),
(58, 1, 2, 774.00, 0.00, 0.00, 'CANCELLED', NULL, '2025-12-01 01:56:13', '2025-12-01 01:57:04', 57),
(59, 1, 2, 99999999.99, 0.00, 0.00, 'CANCELLED', NULL, '2025-12-01 01:56:14', '2025-12-01 01:57:05', 58),
(60, 1, 2, 1419.00, 0.00, 0.00, 'CANCELLED', NULL, '2025-12-01 01:56:22', '2025-12-01 01:57:07', 59),
(61, 1, 2, 1677.00, 0.00, 0.00, 'CANCELLED', NULL, '2025-12-01 01:56:34', '2025-12-01 01:57:10', 60),
(62, 1, 2, 711.00, 0.00, 0.00, 'CANCELLED', NULL, '2025-12-01 01:56:41', '2025-12-01 01:57:12', 61),
(63, 1, 2, 784.00, 0.00, 0.00, 'CANCELLED', NULL, '2025-12-01 01:56:49', '2025-12-01 01:57:14', 62),
(64, 1, 2, 180.00, 10000.00, 9820.00, 'CLAIMED', '2025-12-01 01:57:19', '2025-12-01 01:56:55', '2025-12-01 01:58:04', 63),
(65, 1, 2, 110.00, 10000.00, 9890.00, 'CLAIMED', '2025-12-01 01:57:25', '2025-12-01 01:56:57', '2025-12-01 01:58:08', 64),
(66, 1, 2, 147.00, 0.00, 0.00, 'CANCELLED', NULL, '2025-12-01 01:56:59', '2025-12-01 01:57:03', 65),
(67, 1, 2, 298.00, 500.00, 202.00, 'CLAIMED', '2025-12-01 01:57:22', '2025-12-01 01:57:06', '2025-12-01 01:58:06', 66),
(68, 1, 2, 35.00, 500.00, 465.00, 'CLAIMED', '2025-12-01 01:57:31', '2025-12-01 01:57:19', '2025-12-01 01:58:11', 67),
(69, 1, 2, 1161.00, 10000.00, 8839.00, 'CLAIMED', '2025-12-01 01:57:44', '2025-12-01 01:57:21', '2025-12-01 01:58:13', 68),
(70, 1, 2, 387.00, 10000.00, 9613.00, 'READY_FOR_CLAIM', '2025-12-01 01:57:52', '2025-12-01 01:57:34', '2025-12-01 01:57:55', 69),
(71, 1, 2, 178.00, 1000.00, 822.00, 'CLAIMED', '2025-12-01 01:57:51', '2025-12-01 01:57:35', '2025-12-01 01:57:58', 70),
(72, 1, 2, 90.00, 10000.00, 9910.00, 'CLAIMED', '2025-12-01 01:57:57', '2025-12-01 01:57:41', '2025-12-01 01:58:15', 71),
(73, 1, 2, 110.00, 99999999.99, 99999999.99, 'CLAIMED', '2025-12-01 01:58:02', '2025-12-01 01:57:42', '2025-12-01 01:58:17', 72),
(74, 1, 2, 90.00, 99999999.99, 99999999.99, 'CLAIMED', '2025-12-01 01:58:08', '2025-12-01 01:57:44', '2025-12-01 01:58:19', 73),
(75, 1, 2, 98.00, 99999999.99, 99999999.99, 'CLAIMED', '2025-12-01 01:58:33', '2025-12-01 01:57:46', '2025-12-01 01:58:38', 74),
(76, 1, 2, 262.00, 99999999.99, 99999999.99, 'CLAIMED', '2025-12-01 01:58:13', '2025-12-01 01:57:56', '2025-12-01 01:58:24', 75),
(77, 1, 2, 623.00, 99999999.99, 99999999.99, 'CLAIMED', '2025-12-01 01:58:17', '2025-12-01 01:58:01', '2025-12-01 01:58:22', 76),
(78, 1, 2, 903.00, 99999999.99, 99999999.99, 'CLAIMED', '2025-12-01 01:58:21', '2025-12-01 01:58:04', '2025-12-01 01:58:27', 77),
(79, 1, 2, 645.00, 99999999.99, 99999999.99, 'CLAIMED', '2025-12-01 01:58:26', '2025-12-01 01:58:15', '2025-12-01 01:58:40', 78),
(80, 1, 2, 328.00, 4565.00, 4237.00, 'READY_FOR_CLAIM', '2025-12-01 01:58:46', '2025-12-01 01:58:41', '2025-12-01 01:58:54', 79),
(81, 1, 2, 125.00, 5555.00, 5430.00, 'IN_PROCESS', '2025-12-01 01:58:53', '2025-12-01 01:58:48', '2025-12-01 01:58:53', 80),
(82, 1, NULL, 180.00, 0.00, 0.00, 'UNPAID', NULL, '2025-12-01 01:58:56', '2025-12-01 01:58:56', 81);

-- --------------------------------------------------------

--
-- Table structure for table `order_items`
--

CREATE TABLE `order_items` (
  `id` int(11) NOT NULL,
  `order_id` int(11) NOT NULL,
  `menu_item_id` int(11) NOT NULL,
  `quantity` int(11) NOT NULL DEFAULT 1,
  `price` decimal(10,2) NOT NULL,
  `source` enum('CUSTOMER','TELLER','','') NOT NULL,
  `subtotal` decimal(10,2) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `order_items`
--

INSERT INTO `order_items` (`id`, `order_id`, `menu_item_id`, `quantity`, `price`, `source`, `subtotal`) VALUES
(4, 1, 1, 1, 150.00, 'CUSTOMER', 0.00),
(5, 1, 1, 1, 150.00, 'CUSTOMER', 0.00),
(6, 1, 5, 1, 51581.00, 'TELLER', 0.00),
(8, 2, 1, 1, 150.00, 'CUSTOMER', 0.00),
(9, 3, 1, 1, 150.00, 'CUSTOMER', 0.00),
(12, 4, 1, 1, 150.00, 'CUSTOMER', 0.00),
(13, 4, 4, 1, 45.00, 'CUSTOMER', 0.00),
(16, 5, 1, 1, 150.00, 'CUSTOMER', 0.00),
(17, 5, 3, 1, 60.00, 'CUSTOMER', 0.00),
(20, 6, 1, 1, 150.00, 'CUSTOMER', 0.00),
(21, 6, 6, 1, 815.00, 'CUSTOMER', 0.00),
(24, 7, 3, 1, 60.00, 'CUSTOMER', 0.00),
(25, 7, 4, 1, 45.00, 'CUSTOMER', 0.00),
(27, 8, 3, 1, 60.00, 'CUSTOMER', 0.00),
(49, 14, 28, 3, 99.00, 'CUSTOMER', 0.00),
(50, 14, 33, 1, 59.00, 'CUSTOMER', 0.00),
(51, 14, 35, 2, 35.00, 'CUSTOMER', 0.00),
(52, 14, 40, 1, 49.00, 'CUSTOMER', 0.00),
(53, 14, 37, 2, 25.00, 'TELLER', 0.00),
(54, 15, 27, 1, 79.00, 'CUSTOMER', 0.00),
(55, 15, 30, 1, 89.00, 'CUSTOMER', 0.00),
(56, 15, 33, 1, 59.00, 'CUSTOMER', 0.00),
(57, 15, 36, 1, 30.00, 'CUSTOMER', 0.00),
(58, 15, 40, 1, 49.00, 'CUSTOMER', 0.00),
(87, 13, 28, 28, 99.00, 'CUSTOMER', 0.00),
(88, 13, 30, 1, 89.00, 'CUSTOMER', 0.00),
(89, 13, 31, 316, 149.00, 'CUSTOMER', 0.00),
(90, 13, 34, 1, 35.00, 'CUSTOMER', 0.00),
(91, 13, 38, 1, 45.00, 'CUSTOMER', 0.00),
(92, 13, 31, 35, 149.00, 'TELLER', 0.00),
(93, 13, 30, 14, 89.00, 'TELLER', 0.00),
(100, 17, 40, 6, 49.00, 'CUSTOMER', 0.00),
(101, 24, 28, 1, 99.00, 'CUSTOMER', 0.00),
(102, 24, 32, 1, 39.00, 'CUSTOMER', 0.00),
(103, 24, 36, 1, 30.00, 'CUSTOMER', 0.00),
(104, 24, 39, 1, 55.00, 'CUSTOMER', 0.00),
(136, 9, 8, 1, 242.00, 'CUSTOMER', 0.00),
(137, 11, 10, 1, 340.00, 'CUSTOMER', 0.00),
(145, 19, 31, 79, 149.00, 'CUSTOMER', 0.00),
(151, 20, 28, 1, 99.00, 'CUSTOMER', 0.00),
(152, 20, 33, 1, 59.00, 'CUSTOMER', 0.00),
(153, 20, 36, 1, 30.00, 'CUSTOMER', 0.00),
(154, 20, 39, 1, 55.00, 'CUSTOMER', 0.00),
(155, 22, 27, 21, 79.00, 'CUSTOMER', 0.00),
(156, 22, 28, 8, 99.00, 'CUSTOMER', 0.00),
(157, 22, 29, 14, 129.00, 'CUSTOMER', 0.00),
(158, 22, 30, 1, 89.00, 'CUSTOMER', 0.00),
(159, 22, 31, 6, 149.00, 'CUSTOMER', 0.00),
(160, 22, 32, 4, 39.00, 'CUSTOMER', 0.00),
(161, 22, 33, 2, 59.00, 'CUSTOMER', 0.00),
(162, 22, 34, 4, 35.00, 'CUSTOMER', 0.00),
(163, 22, 35, 3, 35.00, 'CUSTOMER', 0.00),
(164, 22, 36, 4, 30.00, 'CUSTOMER', 0.00),
(165, 22, 37, 2, 25.00, 'CUSTOMER', 0.00),
(166, 22, 38, 9, 45.00, 'CUSTOMER', 0.00),
(167, 22, 39, 5, 55.00, 'CUSTOMER', 0.00),
(168, 22, 40, 5, 49.00, 'CUSTOMER', 0.00),
(169, 27, 27, 8, 79.00, 'CUSTOMER', 0.00),
(170, 27, 28, 6, 99.00, 'CUSTOMER', 0.00),
(171, 27, 29, 7, 129.00, 'CUSTOMER', 0.00),
(172, 27, 30, 5, 89.00, 'CUSTOMER', 0.00),
(173, 27, 31, 6, 149.00, 'CUSTOMER', 0.00),
(174, 27, 35, 2, 35.00, 'CUSTOMER', 0.00),
(175, 27, 36, 2, 30.00, 'CUSTOMER', 0.00),
(176, 27, 38, 4, 45.00, 'CUSTOMER', 0.00),
(177, 27, 39, 2, 55.00, 'CUSTOMER', 0.00),
(178, 27, 40, 2, 49.00, 'CUSTOMER', 0.00),
(179, 27, 28, 5000000, 99.00, 'TELLER', 0.00),
(180, 27, 31, 4000000, 149.00, 'TELLER', 0.00),
(181, 27, 30, 110000, 89.00, 'TELLER', 0.00),
(182, 26, 31, 2147483647, 149.00, 'CUSTOMER', 0.00),
(183, 30, 29, 1, 129.00, 'CUSTOMER', 0.00),
(184, 30, 31, 1, 149.00, 'CUSTOMER', 0.00),
(185, 30, 33, 1, 59.00, 'CUSTOMER', 0.00),
(186, 30, 36, 1, 30.00, 'CUSTOMER', 0.00),
(187, 30, 39, 1, 55.00, 'CUSTOMER', 0.00),
(195, 28, 27, 1, 79.00, 'CUSTOMER', 0.00),
(196, 28, 28, 1, 99.00, 'CUSTOMER', 0.00),
(197, 28, 29, 1, 129.00, 'CUSTOMER', 0.00),
(198, 28, 30, 1, 89.00, 'CUSTOMER', 0.00),
(199, 28, 31, 1, 149.00, 'CUSTOMER', 0.00),
(200, 28, 32, 1, 39.00, 'CUSTOMER', 0.00),
(201, 28, 33, 1, 59.00, 'CUSTOMER', 0.00),
(202, 28, 34, 1, 35.00, 'CUSTOMER', 0.00),
(203, 28, 36, 1, 30.00, 'CUSTOMER', 0.00),
(204, 28, 38, 1, 45.00, 'CUSTOMER', 0.00),
(205, 28, 40, 1, 49.00, 'CUSTOMER', 0.00),
(206, 18, 29, 6, 129.00, 'CUSTOMER', 0.00),
(207, 18, 30, 1, 89.00, 'CUSTOMER', 0.00),
(208, 18, 31, 2, 149.00, 'CUSTOMER', 0.00),
(209, 18, 35, 1, 35.00, 'CUSTOMER', 0.00),
(210, 18, 36, 8, 30.00, 'CUSTOMER', 0.00),
(211, 18, 37, 1, 25.00, 'CUSTOMER', 0.00),
(213, 32, 27, 1, 79.00, 'CUSTOMER', 0.00),
(214, 32, 30, 1, 89.00, 'CUSTOMER', 0.00),
(215, 32, 31, 1, 149.00, 'CUSTOMER', 0.00),
(216, 32, 36, 1, 30.00, 'CUSTOMER', 0.00),
(217, 32, 39, 1, 55.00, 'CUSTOMER', 0.00),
(219, 33, 27, 1, 79.00, 'CUSTOMER', 0.00),
(220, 33, 29, 1, 129.00, 'CUSTOMER', 0.00),
(221, 33, 31, 1, 149.00, 'CUSTOMER', 0.00),
(222, 33, 33, 1, 59.00, 'CUSTOMER', 0.00),
(223, 33, 36, 55555, 30.00, 'CUSTOMER', 0.00),
(224, 33, 38, 1, 45.00, 'CUSTOMER', 0.00),
(225, 33, 39, 1, 55.00, 'CUSTOMER', 0.00),
(226, 34, 35, 13, 35.00, 'CUSTOMER', 0.00),
(227, 35, 29, 8, 129.00, 'CUSTOMER', 0.00),
(229, 10, 1, 1, 150.00, 'CUSTOMER', 0.00),
(230, 10, 6, 1, 815.00, 'CUSTOMER', 0.00),
(233, 12, 27, 1, 79.00, 'CUSTOMER', 0.00),
(234, 12, 28, 2, 99.00, 'CUSTOMER', 0.00),
(235, 12, 40, 1, 49.00, 'CUSTOMER', 0.00),
(236, 16, 28, 5, 99.00, 'CUSTOMER', 0.00),
(245, 21, 31, 1, 149.00, 'CUSTOMER', 0.00),
(252, 40, 29, 5, 129.00, 'CUSTOMER', 0.00),
(253, 40, 32, 20, 39.00, 'CUSTOMER', 0.00),
(254, 40, 33, 286, 59.00, 'CUSTOMER', 0.00),
(255, 40, 36, 7, 30.00, 'CUSTOMER', 0.00),
(256, 38, 27, 3, 79.00, 'CUSTOMER', 0.00),
(259, 36, 31, 2147483647, 149.00, 'CUSTOMER', 0.00),
(260, 39, 31, 8, 149.00, 'CUSTOMER', 0.00),
(261, 39, 38, 7, 45.00, 'CUSTOMER', 0.00),
(262, 39, 39, 6, 55.00, 'CUSTOMER', 0.00),
(263, 39, 40, 5, 49.00, 'CUSTOMER', 0.00),
(264, 37, 27, 10, 79.00, 'CUSTOMER', 0.00),
(265, 41, 27, 10, 79.00, 'CUSTOMER', 0.00),
(266, 41, 29, 8, 129.00, 'CUSTOMER', 0.00),
(267, 41, 30, 14, 89.00, 'CUSTOMER', 0.00),
(269, 43, 27, 16, 79.00, 'CUSTOMER', 0.00),
(270, 43, 29, 24, 129.00, 'CUSTOMER', 0.00),
(271, 42, 27, 28, 79.00, 'CUSTOMER', 0.00),
(272, 42, 29, 4, 129.00, 'CUSTOMER', 0.00),
(273, 42, 30, 14, 89.00, 'CUSTOMER', 0.00),
(275, 44, 30, 19, 89.00, 'CUSTOMER', 0.00),
(278, 23, 28, 17, 99.00, 'CUSTOMER', 0.00),
(281, 25, 28, 1, 99.00, 'CUSTOMER', 0.00),
(285, 53, 27, 3, 79.00, 'CUSTOMER', 0.00),
(286, 29, 31, 1, 149.00, 'CUSTOMER', 0.00),
(287, 29, 33, 1, 59.00, 'CUSTOMER', 0.00),
(288, 29, 36, 1, 30.00, 'CUSTOMER', 0.00),
(289, 29, 39, 1, 55.00, 'CUSTOMER', 0.00),
(290, 54, 40, 2, 49.00, 'CUSTOMER', 0.00),
(291, 55, 39, 2, 55.00, 'CUSTOMER', 0.00),
(292, 31, 29, 1, 129.00, 'CUSTOMER', 0.00),
(293, 31, 31, 1, 149.00, 'CUSTOMER', 0.00),
(294, 31, 33, 1, 59.00, 'CUSTOMER', 0.00),
(295, 31, 37, 1, 25.00, 'CUSTOMER', 0.00),
(296, 31, 38, 1, 45.00, 'CUSTOMER', 0.00),
(297, 31, 39, 1, 55.00, 'CUSTOMER', 0.00),
(298, 31, 40, 1, 49.00, 'CUSTOMER', 0.00),
(299, 56, 38, 7, 45.00, 'CUSTOMER', 0.00),
(300, 56, 39, 2, 55.00, 'CUSTOMER', 0.00),
(301, 45, 29, 25, 129.00, 'CUSTOMER', 0.00),
(302, 57, 40, 6, 49.00, 'CUSTOMER', 0.00),
(303, 58, 29, 6, 129.00, 'CUSTOMER', 0.00),
(304, 59, 28, 2147483647, 99.00, 'CUSTOMER', 0.00),
(305, 59, 29, 2147483647, 129.00, 'CUSTOMER', 0.00),
(306, 46, 27, 13, 79.00, 'CUSTOMER', 0.00),
(307, 60, 29, 11, 129.00, 'CUSTOMER', 0.00),
(308, 47, 38, 7, 45.00, 'CUSTOMER', 0.00),
(309, 48, 39, 2, 55.00, 'CUSTOMER', 0.00),
(310, 61, 29, 13, 129.00, 'CUSTOMER', 0.00),
(311, 49, 40, 2, 49.00, 'CUSTOMER', 0.00),
(312, 50, 31, 2, 149.00, 'CUSTOMER', 0.00),
(313, 62, 27, 9, 79.00, 'CUSTOMER', 0.00),
(314, 51, 30, 5, 89.00, 'CUSTOMER', 0.00),
(315, 63, 40, 16, 49.00, 'CUSTOMER', 0.00),
(316, 52, 29, 3, 129.00, 'CUSTOMER', 0.00),
(319, 66, 40, 3, 49.00, 'CUSTOMER', 0.00),
(321, 64, 38, 4, 45.00, 'CUSTOMER', 0.00),
(324, 67, 31, 2, 149.00, 'CUSTOMER', 0.00),
(325, 65, 39, 2, 55.00, 'CUSTOMER', 0.00),
(326, 68, 34, 1, 35.00, 'CUSTOMER', 0.00),
(332, 69, 29, 9, 129.00, 'CUSTOMER', 0.00),
(334, 71, 30, 2, 89.00, 'CUSTOMER', 0.00),
(335, 70, 29, 3, 129.00, 'CUSTOMER', 0.00),
(340, 72, 38, 2, 45.00, 'CUSTOMER', 0.00),
(342, 73, 39, 2, 55.00, 'CUSTOMER', 0.00),
(344, 74, 38, 2, 45.00, 'CUSTOMER', 0.00),
(345, 76, 28, 1, 99.00, 'CUSTOMER', 0.00),
(346, 76, 30, 1, 89.00, 'CUSTOMER', 0.00),
(347, 76, 37, 1, 25.00, 'CUSTOMER', 0.00),
(348, 76, 40, 1, 49.00, 'CUSTOMER', 0.00),
(350, 77, 30, 7, 89.00, 'CUSTOMER', 0.00),
(351, 78, 29, 7, 129.00, 'CUSTOMER', 0.00),
(352, 79, 29, 5, 129.00, 'CUSTOMER', 0.00),
(353, 75, 40, 2, 49.00, 'CUSTOMER', 0.00),
(356, 80, 30, 2, 89.00, 'CUSTOMER', 0.00),
(357, 80, 37, 6, 25.00, 'CUSTOMER', 0.00),
(359, 81, 37, 5, 25.00, 'CUSTOMER', 0.00),
(360, 82, 36, 6, 30.00, 'CUSTOMER', 0.00);

-- --------------------------------------------------------

--
-- Table structure for table `product_categories`
--

CREATE TABLE `product_categories` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `product_categories`
--

INSERT INTO `product_categories` (`id`, `name`, `created_at`) VALUES
(1, 'Burgers', '2025-12-01 01:38:45'),
(2, 'Chicken', '2025-12-01 01:38:45'),
(3, 'Fries & Sides', '2025-12-01 01:38:45'),
(4, 'Drinks', '2025-12-01 01:38:45'),
(5, 'Desserts', '2025-12-01 02:20:08');

-- --------------------------------------------------------

--
-- Table structure for table `terminals`
--

CREATE TABLE `terminals` (
  `id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `type` enum('CUSTOMER','TELLER','KITCHEN','CLAIM') NOT NULL,
  `employee_name` varchar(100) NOT NULL,
  `pin_code` char(6) NOT NULL,
  `is_active` tinyint(1) NOT NULL DEFAULT 1,
  `created_at` timestamp NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;

--
-- Dumping data for table `terminals`
--

INSERT INTO `terminals` (`id`, `name`, `type`, `employee_name`, `pin_code`, `is_active`, `created_at`) VALUES
(1, 'KIOSK1', 'CUSTOMER', 'KIOSK1', '013259', 1, '2025-12-01 01:24:52'),
(2, 'TELLER1', 'TELLER', 'TELLER1', '405479', 1, '2025-12-01 04:20:38'),
(3, 'KITCHEN1', 'KITCHEN', 'KITCHEN1', '336714', 1, '2025-12-01 06:17:58'),
(4, 'CLAIMING1', 'CLAIM', 'CLAIMING1', '888086', 1, '2025-12-01 06:23:18'),
(5, 'CLAIMING1', 'CLAIM', 'CLAIMING1', '747586', 1, '2025-12-01 06:24:00');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `bundles`
--
ALTER TABLE `bundles`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `bundle_items`
--
ALTER TABLE `bundle_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `fk_bundle_items_bundle` (`bundle_id`),
  ADD KEY `fk_bundle_items_item` (`menu_item_id`);

--
-- Indexes for table `menu_items`
--
ALTER TABLE `menu_items`
  ADD PRIMARY KEY (`id`),
  ADD UNIQUE KEY `code` (`code`),
  ADD KEY `fk_menu_items_category` (`category_id`);

--
-- Indexes for table `orders`
--
ALTER TABLE `orders`
  ADD PRIMARY KEY (`id`),
  ADD KEY `terminal_id` (`terminal_id`),
  ADD KEY `teller_terminal_id` (`teller_terminal_id`);

--
-- Indexes for table `order_items`
--
ALTER TABLE `order_items`
  ADD PRIMARY KEY (`id`),
  ADD KEY `order_id` (`order_id`),
  ADD KEY `menu_item_id` (`menu_item_id`);

--
-- Indexes for table `product_categories`
--
ALTER TABLE `product_categories`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `terminals`
--
ALTER TABLE `terminals`
  ADD PRIMARY KEY (`id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `bundles`
--
ALTER TABLE `bundles`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `bundle_items`
--
ALTER TABLE `bundle_items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=30;

--
-- AUTO_INCREMENT for table `menu_items`
--
ALTER TABLE `menu_items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=53;

--
-- AUTO_INCREMENT for table `orders`
--
ALTER TABLE `orders`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=83;

--
-- AUTO_INCREMENT for table `order_items`
--
ALTER TABLE `order_items`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=361;

--
-- AUTO_INCREMENT for table `product_categories`
--
ALTER TABLE `product_categories`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `terminals`
--
ALTER TABLE `terminals`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `bundle_items`
--
ALTER TABLE `bundle_items`
  ADD CONSTRAINT `fk_bundle_items_bundle` FOREIGN KEY (`bundle_id`) REFERENCES `menu_items` (`id`) ON DELETE CASCADE,
  ADD CONSTRAINT `fk_bundle_items_item` FOREIGN KEY (`menu_item_id`) REFERENCES `menu_items` (`id`) ON DELETE CASCADE;

--
-- Constraints for table `menu_items`
--
ALTER TABLE `menu_items`
  ADD CONSTRAINT `fk_menu_items_category` FOREIGN KEY (`category_id`) REFERENCES `product_categories` (`id`);

--
-- Constraints for table `orders`
--
ALTER TABLE `orders`
  ADD CONSTRAINT `orders_ibfk_1` FOREIGN KEY (`terminal_id`) REFERENCES `terminals` (`id`),
  ADD CONSTRAINT `orders_ibfk_2` FOREIGN KEY (`teller_terminal_id`) REFERENCES `terminals` (`id`);

--
-- Constraints for table `order_items`
--
ALTER TABLE `order_items`
  ADD CONSTRAINT `order_items_ibfk_1` FOREIGN KEY (`order_id`) REFERENCES `orders` (`id`),
  ADD CONSTRAINT `order_items_ibfk_2` FOREIGN KEY (`menu_item_id`) REFERENCES `menu_items` (`id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
