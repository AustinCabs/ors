-- phpMyAdmin SQL Dump
-- version 5.0.4
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jun 24, 2021 at 02:37 AM
-- Server version: 10.4.17-MariaDB
-- PHP Version: 7.3.25

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
-- Table structure for table `check_in`
--

CREATE TABLE `check_in` (
  `check_in_id` int(11) NOT NULL,
  `customer_id` int(11) DEFAULT NULL,
  `reservation_id` int(11) DEFAULT NULL,
  `is_paid` int(1) DEFAULT 0,
  `is_assigned` int(1) NOT NULL DEFAULT 0,
  `total_rate` double NOT NULL,
  `date_approved` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- --------------------------------------------------------

--
-- Stand-in structure for view `check_in_list`
-- (See below for the actual view)
--
CREATE TABLE `check_in_list` (
`check_in_id` int(11)
,`reservation_id` int(11)
,`customer_id` int(11)
,`customer_name` text
,`phone_num` varchar(255)
,`is_paid` int(1)
,`is_assign` int(1)
,`total_rate` double
,`date_approved` timestamp
,`room_size` int(11)
,`room_qty` int(11)
);

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

-- --------------------------------------------------------

--
-- Table structure for table `room_assigned`
--

CREATE TABLE `room_assigned` (
  `room_assigned_id` int(11) NOT NULL,
  `room_size_id` int(11) DEFAULT NULL,
  `room_id` int(11) DEFAULT NULL,
  `check_in_id` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

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

-- --------------------------------------------------------

--
-- Stand-in structure for view `vw_reservation`
-- (See below for the actual view)
--
CREATE TABLE `vw_reservation` (
`reservation_id` int(11)
,`room_qty` int(11)
,`check_in_date` date
,`check_out_date` date
,`customer_id` int(11)
,`customer_name` text
,`address` varchar(255)
,`phone_num` varchar(255)
,`room_type_id` int(11)
,`room_size_name` varchar(255)
,`rate` double
,`status` varchar(255)
,`date_posted` varchar(21)
);

-- --------------------------------------------------------

--
-- Structure for view `check_in_list`
--
DROP TABLE IF EXISTS `check_in_list`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `check_in_list`  AS SELECT `ci`.`check_in_id` AS `check_in_id`, `r`.`reservation_id` AS `reservation_id`, `c`.`customer_id` AS `customer_id`, concat(`c`.`firstname`,' ',`c`.`middlename`,' ',`c`.`lastname`) AS `customer_name`, `c`.`phone_num` AS `phone_num`, `ci`.`is_paid` AS `is_paid`, `ci`.`is_assigned` AS `is_assign`, `ci`.`total_rate` AS `total_rate`, `ci`.`date_approved` AS `date_approved`, `r`.`room_type` AS `room_size`, `r`.`room_qty` AS `room_qty` FROM ((`check_in` `ci` join `reservations` `r` on(`ci`.`reservation_id` = `r`.`reservation_id`)) join `customers` `c` on(`ci`.`customer_id` = `c`.`customer_id`)) ;

-- --------------------------------------------------------

--
-- Structure for view `reservation_list`
--
DROP TABLE IF EXISTS `reservation_list`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `reservation_list`  AS SELECT concat(`c`.`firstname`,' ',`c`.`middlename`,' ',`c`.`lastname`) AS `customer`, `rs`.`room_size_name` AS `room_size_name`, `r`.`room_qty` AS `room_qty`, `r`.`check_in_date` AS `check_in_date`, `r`.`check_out_date` AS `check_out_date`, `r`.`created_at` AS `created_at`, `r`.`status` AS `status` FROM ((`reservations` `r` join `customers` `c` on(`r`.`customer_id` = `c`.`customer_id`)) join `room_size` `rs` on(`r`.`room_type` = `rs`.`room_type_id`)) ;

-- --------------------------------------------------------

--
-- Structure for view `vw_reservation`
--
DROP TABLE IF EXISTS `vw_reservation`;

CREATE ALGORITHM=UNDEFINED DEFINER=`root`@`localhost` SQL SECURITY DEFINER VIEW `vw_reservation`  AS SELECT `r`.`reservation_id` AS `reservation_id`, `r`.`room_qty` AS `room_qty`, `r`.`check_in_date` AS `check_in_date`, `r`.`check_out_date` AS `check_out_date`, `c`.`customer_id` AS `customer_id`, concat(`c`.`firstname`,' ',`c`.`middlename`,' ',`c`.`lastname`) AS `customer_name`, `c`.`address` AS `address`, `c`.`phone_num` AS `phone_num`, `rs`.`room_type_id` AS `room_type_id`, `rs`.`room_size_name` AS `room_size_name`, `rs`.`rate` AS `rate`, `r`.`status` AS `status`, date_format(`r`.`created_at`,'%d/%m/%Y %H:%i') AS `date_posted` FROM ((`reservations` `r` join `customers` `c` on(`r`.`customer_id` = `c`.`customer_id`)) join `room_size` `rs` on(`r`.`room_type` = `rs`.`room_type_id`)) ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `accounts`
--
ALTER TABLE `accounts`
  ADD PRIMARY KEY (`id`);

--
-- Indexes for table `check_in`
--
ALTER TABLE `check_in`
  ADD PRIMARY KEY (`check_in_id`);

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
-- Indexes for table `room_assigned`
--
ALTER TABLE `room_assigned`
  ADD PRIMARY KEY (`room_assigned_id`);

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
-- AUTO_INCREMENT for table `check_in`
--
ALTER TABLE `check_in`
  MODIFY `check_in_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `customers`
--
ALTER TABLE `customers`
  MODIFY `customer_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `payments`
--
ALTER TABLE `payments`
  MODIFY `payment_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `reservations`
--
ALTER TABLE `reservations`
  MODIFY `reservation_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `rooms`
--
ALTER TABLE `rooms`
  MODIFY `room_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `room_assigned`
--
ALTER TABLE `room_assigned`
  MODIFY `room_assigned_id` int(11) NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `room_size`
--
ALTER TABLE `room_size`
  MODIFY `room_type_id` int(11) NOT NULL AUTO_INCREMENT;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
