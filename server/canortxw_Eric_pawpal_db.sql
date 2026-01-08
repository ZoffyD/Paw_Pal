-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: localhost:3306
-- Generation Time: Jan 08, 2026 at 10:37 PM
-- Server version: 10.3.39-MariaDB-log-cll-lve
-- PHP Version: 8.1.34

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `canortxw_Eric_pawpal_db`
--

-- --------------------------------------------------------

--
-- Table structure for table `tbl_adoptions`
--

CREATE TABLE `tbl_adoptions` (
  `adoption_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `pet_id` int(11) NOT NULL,
  `request_date` datetime NOT NULL DEFAULT current_timestamp(),
  `motivation` text NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_adoptions`
--

INSERT INTO `tbl_adoptions` (`adoption_id`, `user_id`, `pet_id`, `request_date`, `motivation`) VALUES
(1, 3, 5, '2026-01-08 21:00:31', 'rara is cute and I am capable to adopt rara, I have stable income'),
(2, 3, 5, '2026-01-08 21:00:32', 'rara is cute and I am capable to adopt rara, I have stable income'),
(3, 3, 5, '2026-01-08 21:01:45', 'I would like to adopt rara');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_donations`
--

CREATE TABLE `tbl_donations` (
  `donation_id` int(11) NOT NULL,
  `pet_id` int(11) DEFAULT NULL,
  `user_id` int(11) DEFAULT NULL,
  `donation_type` varchar(20) DEFAULT NULL,
  `amount` double(10,2) DEFAULT 0.00,
  `description` text DEFAULT NULL,
  `donation_date` datetime DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_donations`
--

INSERT INTO `tbl_donations` (`donation_id`, `pet_id`, `user_id`, `donation_type`, `amount`, `description`, `donation_date`) VALUES
(1, 1, 1, 'Money', 40.00, '', '2026-01-05 21:04:57'),
(2, 1, 1, 'Food', 0.00, '1 pack of food', '2026-01-07 16:39:54'),
(3, 1, 1, 'Money', 11.00, '', '2026-01-07 16:42:53'),
(4, 3, 3, 'Money', 20.00, '', '2026-01-08 22:22:29');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_pets`
--

CREATE TABLE `tbl_pets` (
  `pet_id` int(11) NOT NULL,
  `user_id` int(11) NOT NULL,
  `pet_name` varchar(100) NOT NULL,
  `age` int(100) NOT NULL,
  `gender` varchar(50) NOT NULL,
  `pet_type` varchar(50) NOT NULL,
  `category` varchar(50) NOT NULL,
  `health` varchar(50) NOT NULL,
  `description` text NOT NULL,
  `image_paths` text NOT NULL,
  `lat` varchar(50) NOT NULL,
  `lng` varchar(50) NOT NULL,
  `created_at` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_pets`
--

INSERT INTO `tbl_pets` (`pet_id`, `user_id`, `pet_name`, `age`, `gender`, `pet_type`, `category`, `health`, `description`, `image_paths`, `lat`, `lng`, `created_at`) VALUES
(1, 2, 'Boo', 2, 'male', 'Cat', 'Donation Request', 'unhealthy', 'boo needs help to cure', 'pet_1_1.png', '6.4607067', '100.505145', '2026-01-05 21:04:03'),
(2, 1, 'ken', 2, 'male', 'Cat', 'Adoption', 'healthy', 'ken is so cute and funny ', 'pet_2_1.png', '6.4607067', '100.505145', '2026-01-07 16:37:57'),
(3, 1, 'golden', 4, 'male', 'Dog', 'Donation Request', 'unhealthy', 'golden is now suffering ', 'pet_3_1.png, pet_3_2.png', '6.4607067', '100.505145', '2026-01-08 17:56:46'),
(5, 1, 'rara', 5, 'female', 'Rabbit', 'Adoption', 'healthy', 'rara needs a house to feel warm', 'pet_5_1.png', '6.4607067', '100.505145', '2026-01-08 19:39:52'),
(6, 3, 'Oyen', 6, 'male', 'Cat', 'Donation Request', 'unhealthy', 'oyen is in emergency due to gall bladder failure\n', 'pet_6_1.png', '6.4607067', '100.505145', '2026-01-08 20:04:32');

-- --------------------------------------------------------

--
-- Table structure for table `tbl_users`
--

CREATE TABLE `tbl_users` (
  `user_id` int(11) NOT NULL,
  `name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `password` varchar(255) NOT NULL,
  `phone` varchar(20) NOT NULL,
  `wallet` decimal(10,2) NOT NULL DEFAULT 0.00,
  `reg_date` datetime NOT NULL DEFAULT current_timestamp(),
  `profile_image` varchar(255) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `tbl_users`
--

INSERT INTO `tbl_users` (`user_id`, `name`, `email`, `password`, `phone`, `wallet`, `reg_date`, `profile_image`) VALUES
(1, 'jun', 'jun@gmail.com', '7c4a8d09ca3762af61e59520943dc26494f8941b', '0123456789', 90.00, '2026-01-05 20:10:24', 'person1.png'),
(2, 'bakkien', 'bakkien@gmail.com', '7c4a8d09ca3762af61e59520943dc26494f8941b', '0123456789', 51.00, '2026-01-05 21:02:12', NULL),
(3, 'erica', 'erica@gmail.com', '7c4a8d09ca3762af61e59520943dc26494f8941b', '01138814678', 30.00, '2026-01-08 17:41:13', 'person3.png');

--
-- Indexes for dumped tables
--

--
-- Indexes for table `tbl_adoptions`
--
ALTER TABLE `tbl_adoptions`
  ADD PRIMARY KEY (`adoption_id`);

--
-- Indexes for table `tbl_donations`
--
ALTER TABLE `tbl_donations`
  ADD PRIMARY KEY (`donation_id`);

--
-- Indexes for table `tbl_pets`
--
ALTER TABLE `tbl_pets`
  ADD PRIMARY KEY (`pet_id`);

--
-- Indexes for table `tbl_users`
--
ALTER TABLE `tbl_users`
  ADD PRIMARY KEY (`user_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `tbl_adoptions`
--
ALTER TABLE `tbl_adoptions`
  MODIFY `adoption_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `tbl_donations`
--
ALTER TABLE `tbl_donations`
  MODIFY `donation_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `tbl_pets`
--
ALTER TABLE `tbl_pets`
  MODIFY `pet_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `tbl_users`
--
ALTER TABLE `tbl_users`
  MODIFY `user_id` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
