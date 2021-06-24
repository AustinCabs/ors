-- phpMyAdmin SQL Dump
-- version 5.0.2
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: May 20, 2021 at 12:51 PM
-- Server version: 10.4.14-MariaDB
-- PHP Version: 7.3.21

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `ors`
--

-- --------------------------------------------------------

--
-- Table structure for table `accounts`
--

CREATE TABLE `accounts` (
  `id` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `customers`
--

CREATE TABLE `customers` (
  `customer_id` int(11) NOT NULL,
  `firstname` varchar(255) DEFAULT NULL,
  `middlename` varchar(255) DEFAULT NULL,
  `lastname` varchar(255) DEFAULT NULL,
  `address` varchar(255) DEFAULT NULL,
  `dob` date DEFAULT NULL,
  `phone_num` varchar(255) DEFAULT NULL,
  `bank_account_num` varchar(255) DEFAULT NULL,
  `bank_name` varchar(255) DEFAULT NULL,
  `bank_account_name` varchar(255) DEFAULT NULL,
  `gcash` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `customers`
--

INSERT INTO `customers` (`customer_id`, `firstname`, `middlename`, `lastname`, `address`, `dob`, `phone_num`, `bank_account_num`, `bank_name`, `bank_account_name`, `gcash`) VALUES
(1, 'camela', 'bal', 'eds', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(2, 'cams', 'bals', 'eds', NULL, NULL, NULL, NULL, NULL, NULL, NULL),
(3, 'Camela', 'Bals', 'Eden', NULL, NULL, NULL, NULL, NULL, NULL, NULL);

-- --------------------------------------------------------

--
-- Table structure for table `payments`
--

CREATE TABLE `payments` (
  `payment_id` int(11) NOT NULL,
  `is_paid` bit(1) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Table structure for table `reservations`
--

CREATE TABLE `reservations` (
  `reservation_id` int(11) NOT NULL,
  `customer_id` int(11) DEFAULT NULL,
  `room_type` int(11) DEFAULT NULL,
  `room_qty` int(11) NOT NULL,
  `check_in_date` date DEFAULT NULL,
  `check_out_date` date DEFAULT NULL,
  `status` varchar(255) DEFAULT NULL,
  `created_at` timestamp NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `reservations`
--

INSERT INTO `reservations` (`reservation_id`, `customer_id`, `room_type`, `room_qty`, `check_in_date`, `check_out_date`, `status`, `created_at`) VALUES
(1, 1, 1, 2, '2021-05-15', '2021-05-15', 'Pending', '2021-05-15 01:54:09'),
(2, 2, 1, 2, '2021-05-16', '2021-05-16', 'Pending', '2021-05-15 02:07:55'),
(3, 3, 1, 2, '2021-05-17', '2021-05-17', 'Pending', '2021-05-15 02:50:59');

-- --------------------------------------------------------

--
-- Stand-in structure for view `reservation_list`
-- (See below for the actual view)
--
CREATE TABLE `reservation_list` (
`customer` text
,`room_size_name` varchar(255)
,`room_qty` int(11)
,`check_in_date` date
,`check_out_date` date
,`created_at` timestamp
,`status` varchar(255)
);

-- --------------------------------------------------------

--
-- Table structure for table `rooms`
--

CREATE TABLE `rooms` (
  `room_id` int(11) NOT NULL,
  `room_num` varchar(255) DEFAULT NULL,
  `room_type_id` int(11) DEFAULT NULL,
  `is_available` bit(1) NOT NULL DEFAULT b'1'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `rooms`
--

INSERT INTO `rooms` (`room_id`, `room_num`, `room_type_id`, `is_available`) VALUES
(1, NULL, 1, b'1'),
(2, NULL, 1, b'1'),
(3, NULL, 1, b'1'),
(4, NULL, 1, b'1'),
(5, NULL, 1, b'1'),
(6, NULL, 1, b'1'),
(7, NULL, 1, b'1'),
(8, NULL, 1, b'1'),
(9, NULL, 1, b'1'),
(10, NULL, 1, b'1'),
(11, NULL, 1, b'1'),
(12, NULL, 1, b'1'),
(13, NULL, 1, b'1'),
(14, NULL, 1, b'1'),
(15, NULL, 1, b'1'),
(16, NULL, 1, b'1'),
(17, NULL, 1, b'1'),
(18, NULL, 1, b'1'),
(19, NULL, 1, b'1'),
(20, NULL, 1, b'1');

-- --------------------------------------------------------

--
-- Table structure for table `room_size`
--

CREATE TABLE `room_size` (
  `room_type_id` int(11) NOT NULL,
  `room_size_name` varchar(255) NOT NULL,
  `rate` double DEFAULT NULL,
  `pic` varchar(255) DEFAULT NULL,
  `description` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

--
-- Dumping data for table `room_size`
--

INSERT INTO `room_size` (`room_type_id`, `room_size_name`, `rate`, `pic`, `description`) VALUES
(1, 'Deluxe Twin', 100, '1621042951658.jpg', 'good for 2 people'),
(2, 'ordinary', 1000, '1621045837722.jpg', 'good for two'),
(3, 'King size ', 2000, '1621047134452.jpg', 'good for family'),
(4, 'superior room', 1000, '1621047478511.jpg', 'good for three');

-- --------------------------------------------------------

--
-- Structure for view `reservation_list`
--
DROP TABLE IF EXISTS `reservation_list`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `reservation_list`  AS  select concat(`c`.`firstname`,' ',`c`.`middlename`,' ',`c`.`lastname`) AS `customer`,`rs`.`room_size_name` AS `room_size_name`,`r`.`room_qty` AS `room_qty`,`r`.`check_in_date` AS `check_in_date`,`r`.`check_out_date` AS `check_out_date`,`r`.`created_at` AS `created_at`,`r`.`status` AS `status` from ((`reservations` `r` join `customers` `c` on(`r`.`customer_id` = `c`.`customer_id`)) join `room_size` `rs` on(`r`.`room_type` = `rs`.`room_type_id`)) ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `accounts`
--
ALTER TABLE `accounts`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `customers`
--
ALTER TABLE `customers`
  ADD PRIMARY KEY (`customer_id`);

--
-- Indexes for table `payments`
--
ALTER TABLE `payments`
  ADD PRIMARY KEY (`payment_id`);

--
-- Indexes for table `reservations`
--
ALTER TABLE `reservations`
  ADD PRIMARY KEY (`reservation_id`);

--
-- Indexes for table `rooms`
--
ALTER TABLE `rooms`
  ADD PRIMARY KEY (`room_id`);

--
-- Indexes for table `room_size`
--
ALTER TABLE `room_size`
  ADD PRIMARY KEY (`room_type_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `accounts`
--
ALTER TABLE `accounts`
  MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `customers`
--
ALTER TABLE `customers`
  MODIFY `customer_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `payments`
--
ALTER TABLE `payments`
  MODIFY `payment_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `reservations`
--
ALTER TABLE `reservations`
  MODIFY `reservation_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `rooms`
--
ALTER TABLE `rooms`
  MODIFY `room_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;

--
-- AUTO_INCREMENT for table `room_size`
--
ALTER TABLE `room_size`
  MODIFY `room_type_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
